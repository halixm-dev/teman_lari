"""
Bridge: Antigravity (Gemini CLI) SQLite DB → OpenCode legacy format (for Coach).
"""

import json
import os
import sqlite3
import sys
import uuid as uuid_mod
from datetime import datetime, timezone
from glob import glob

from google.protobuf.internal import decoder

ANTIGRAVITY_DIR = os.path.expanduser(r'~\.gemini\antigravity\conversations')
OUTPUT_DIR = os.path.expanduser(r'~\.local\share\opencode\legacy-for-coach-from-antigravity')

# ─── protobuf helpers ───────────────────────────────────────────────

def _decode_raw_fields(data):
    """Yield (field_num, wire_type, value) for a protobuf message."""
    pos = 0
    while pos < len(data):
        key, pos = decoder._DecodeVarint32(data, pos)
        field_num = key >> 3
        wire_type = key & 0x7
        if wire_type == 0:
            val, pos = decoder._DecodeVarint(data, pos)
            yield field_num, wire_type, val
        elif wire_type == 2:
            length, pos = decoder._DecodeVarint32(data, pos)
            val = data[pos:pos+length]
            pos += length
            yield field_num, wire_type, val
        elif wire_type == 5:
            import struct
            val = struct.unpack('<I', data[pos:pos+4])[0]
            pos += 4
            yield field_num, wire_type, val
        elif wire_type == 1:
            import struct
            val = struct.unpack('<Q', data[pos:pos+8])[0]
            pos += 8
            yield field_num, wire_type, val
        else:
            break


def _get_field(data, target_num):
    """Get value of first occurrence of field_num from a protobuf message."""
    for num, wt, val in _decode_raw_fields(data):
        if num == target_num:
            return val
    return None


def _get_all_fields(data, target_num):
    """Get all values of a repeated field."""
    return [val for num, wt, val in _decode_raw_fields(data) if num == target_num]


def _decode_timestamp(ts_bytes):
    """Decode protobuf Timestamp message → epoch seconds (float)."""
    secs = _get_field(ts_bytes, 1)
    nanos = _get_field(ts_bytes, 2)
    if secs is None:
        return None
    return secs + (nanos or 0) / 1e9


def _get_timestamp_from_meta(meta_bytes, field_num=1):
    """Extract a Timestamp from a field in the metadata."""
    ts_field = _get_field(meta_bytes, field_num)
    if ts_field and isinstance(ts_field, bytes):
        return _decode_timestamp(ts_field)
    return None


def _get_str_field(data, field_num):
    v = _get_field(data, field_num)
    if isinstance(v, bytes):
        try:
            return v.decode('utf-8')
        except UnicodeDecodeError:
            pass
    return None


def _decode_nested_message(data):
    """Parse a nested protobuf message and return dict of field→value."""
    result = {}
    for num, wt, val in _decode_raw_fields(data):
        if isinstance(val, bytes):
            try:
                text = val.decode('utf-8')
                result[num] = text
            except UnicodeDecodeError:
                result[num] = val.hex()
        else:
            result[num] = val
    return result


# ─── Step parsers ───────────────────────────────────────────────────

def parse_step_14(payload):
    """User message."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    f19 = _get_field(payload, 19)
    text = ''
    if f19 and isinstance(f19, bytes):
        text = _get_str_field(f19, 2) or ''
    return meta, {'role': 'user', 'parts': [{'type': 'text', 'text': text}]}


def parse_step_15(payload):
    """Assistant response with optional tool calls."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    f20 = _get_field(payload, 20)
    text = ''
    thinking = ''
    tool_calls = []
    tokens_input = 0
    tokens_output = 0
    if f20 and isinstance(f20, bytes):
        text = _get_str_field(f20, 1) or ''
        thinking = _get_str_field(f20, 3) or ''
        for tc_field in _get_all_fields(f20, 7):
            if isinstance(tc_field, bytes):
                tc_id = _get_str_field(tc_field, 1) or ''
                tc_name = _get_str_field(tc_field, 2) or ''
                tc_args = _get_str_field(tc_field, 3) or ''
                tool_calls.append({'id': tc_id, 'name': tc_name, 'args': tc_args})
        # Token info (field 11)
        tok_field = _get_field(f20, 11)
        if tok_field and isinstance(tok_field, bytes):
            tokens_input = _get_field(tok_field, 1) or 0
            tokens_output = _get_field(tok_field, 2) or 0
    parts = []
    if thinking:
        parts.append({'type': 'reasoning', 'text': thinking})
    if text:
        parts.append({'type': 'text', 'text': text})
    for tc in tool_calls:
        parts.append({
            'type': 'tool',
            'tool': tc['name'],
            'callID': tc['id'],
            'text': tc['args']
        })
    if not parts:
        parts.append({'type': 'text', 'text': ''})
    return meta, {'role': 'assistant', 'parts': parts, 'tokensIn': tokens_input, 'tokensOut': tokens_output}


def parse_step_9(payload):
    """Tool result (returned from tool execution)."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    f15 = _get_field(payload, 15)
    text = ''
    if f15 and isinstance(f15, bytes):
        text = _get_str_field(f15, 1) or ''
        # Additional file info in F3
    tool_name = _get_str_field(meta_field, 4) if meta_field and isinstance(meta_field, bytes) else ''
    return meta, {'role': 'tool', 'parts': [{'type': 'tool', 'text': text, 'tool': tool_name, 'state': 'success'}]}


def parse_step_8(payload):
    """Tool result / observation."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    text = ''
    # Step type 8 content may be in F15 or other fields
    for candidate in [15, 16, 19, 20]:
        f = _get_field(payload, candidate)
        if f and isinstance(f, bytes):
            t = _get_str_field(f, 1) or _get_str_field(f, 2) or ''
            if t:
                text = t
                break
    return meta, {'role': 'tool', 'parts': [{'type': 'tool', 'text': text, 'state': 'success'}]}


def parse_step_23(payload):
    """Reasoning / thinking step."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    # Reasoning content may be in F20 → F3 (thinking) or F19
    text = ''
    for candidate in [19, 20]:
        f = _get_field(payload, candidate)
        if f and isinstance(f, bytes):
            t = _get_str_field(f, 3) or _get_str_field(f, 2) or _get_str_field(f, 1) or ''
            if t:
                text = t
                break
    return meta, {'role': 'assistant', 'parts': [{'type': 'reasoning', 'text': text}]}


def parse_step_7(payload):
    """Tool observation/result."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    text = ''
    for candidate in [15, 16, 19]:
        f = _get_field(payload, candidate)
        if f and isinstance(f, bytes):
            t = _get_str_field(f, 1) or ''
            if t:
                text = t
                break
    return meta, {'role': 'tool', 'parts': [{'type': 'tool', 'text': text, 'state': 'success'}]}


def parse_step_17(payload):
    """Error / special step."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    return meta, {'role': 'tool', 'parts': [{'type': 'tool', 'text': '', 'state': 'error'}]}


def parse_step_21(payload):
    """Tool result (encrypted F7)."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    # Tool call info in F5->F4
    f4 = None
    if meta_field and isinstance(meta_field, bytes):
        f4 = _get_field(meta_field, 4)
    tool_name = ''
    tool_args = ''
    tool_call_id = ''
    if f4 and isinstance(f4, bytes):
        tool_call_id = _get_str_field(f4, 1) or ''
        tool_name = _get_str_field(f4, 2) or ''
        tool_args = _get_str_field(f4, 3) or ''
    return meta, {
        'role': 'tool',
        'parts': [{'type': 'tool', 'text': tool_args, 'tool': tool_name, 'callID': tool_call_id, 'state': 'success', 'reason': 'encrypted result'}]
    }


def parse_step_90(payload):
    """System context injection. Filter out - not a conversation step."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    f103 = _get_field(payload, 103)
    text = ''
    if f103 and isinstance(f103, bytes):
        text = _get_str_field(f103, 1) or ''
    return meta, {'role': 'system', 'parts': [{'type': 'text', 'text': text}]}


def parse_step_98(payload):
    """Context injection (prior conversation history). Filter out."""
    meta_field = _get_field(payload, 5)
    meta = _parse_meta(meta_field) if meta_field and isinstance(meta_field, bytes) else {}
    return meta, {'role': 'system', 'parts': [{'type': 'text', 'text': '[context injection]'}]}


STEP_PARSERS = {
    14: parse_step_14,
    15: parse_step_15,
    9: parse_step_9,
    8: parse_step_8,
    23: parse_step_23,
    7: parse_step_7,
    17: parse_step_17,
    21: parse_step_21,
    90: parse_step_90,
    98: parse_step_98,
}


def _parse_meta(meta_bytes):
    """Extract key info from metadata protobuf."""
    meta = {}
    f1 = _get_field(meta_bytes, 1)
    if f1 and isinstance(f1, bytes):
        meta['timestamp'] = _decode_timestamp(f1)
    f3 = _get_field(meta_bytes, 3)
    if f3 is not None:
        meta['status'] = f3
    f12 = _get_str_field(meta_bytes, 12)
    if f12:
        meta['conversation_id'] = f12
    f20 = _get_str_field(meta_bytes, 20)
    if f20:
        meta['trajectory_info'] = f20
    # F9 may contain session metadata
    f9 = _get_field(meta_bytes, 9)
    if f9 and isinstance(f9, bytes):
        f8 = _get_str_field(f9, 8)
        if f8:
            meta['session_id_raw'] = f8
        f11 = _get_str_field(f9, 11)
        if f11:
            meta['request_id'] = f11
    f21 = _get_field(meta_bytes, 21)
    if f21 is not None:
        meta['step_index'] = f21
    return meta


# ─── Coach format builders ──────────────────────────────────────────

def build_session(traj_id, cascade_id, traj_type, source, steps_data, meta_blob):
    """Build session/global/<id>.json"""
    title = ''
    created_ts = None
    
    # First pass: find created_ts and title (separate loops)
    for sd in steps_data:
        if sd.get('timestamp') and created_ts is None:
            created_ts = sd['timestamp']
        if not title and sd.get('role') == 'user':
            for p in sd.get('parts', []):
                if p.get('type') == 'text' and p.get('text'):
                    title = p['text'][:100]
                    break
    
    updated_ts = None
    for sd in reversed(steps_data):
        if sd.get('timestamp'):
            updated_ts = sd['timestamp']
            break
    
    session = {
        'id': traj_id,
        'slug': cascade_id or traj_id,
        'version': 1,
        'projectID': '',
        'directory': '',
        'title': title,
        'time': {
            'created': created_ts or 0,
            'updated': updated_ts or 0,
        }
    }
    return session


def build_message_and_parts(idx, step_type, step_status, parsed_meta, parsed_content, traj_id):
    """Build message/<sid>/<mid>.json and part/<mid>/<pid>.json pairs."""
    msg_id = str(uuid_mod.uuid4())
    
    ts = parsed_meta.get('timestamp', 0)
    role = parsed_content['role']
    
    finish_reason = None
    if step_status == 3:
        finish_reason = 'completed'
    
    msg = {
        'id': msg_id,
        'sessionID': traj_id,
        'role': role,
        'time': {
            'created': ts,
            'completed': ts,
        },
        'parentID': None,
        'modelID': 'gemini-2.5-pro',
        'providerID': 'gemini',
        'mode': 'antigravity',
        'agent': 'antigravity-gemini-cli',
        'cost': 0,
        'tokens': {
            'input': parsed_content.get('tokensIn', 0),
            'output': parsed_content.get('tokensOut', 0),
        },
        'finish': finish_reason,
        'summary': '',
        'variant': '',
        'model': 'gemini-2.5-pro',
        'stepType': step_type,
    }
    
    parts = []
    for pi, part in enumerate(parsed_content.get('parts', [])):
        part_id = str(uuid_mod.uuid4())
        part_obj = {
            'id': part_id,
            'sessionID': traj_id,
            'messageID': msg_id,
            'type': part['type'],
            'text': part.get('text', ''),
            'tool': part.get('tool', None),
            'callID': part.get('callID', None),
            'state': part.get('state', None),
            'tokens': parsed_content.get('tokensIn', 0) if part['type'] == 'tool' else 0,
            'cost': 0,
            'reason': part.get('reason', None),
        }
        parts.append(part_obj)
    
    return msg_id, msg, parts


def format_ts(epoch_secs):
    """Format epoch seconds to ISO string."""
    if not epoch_secs:
        return None
    try:
        dt = datetime.fromtimestamp(float(epoch_secs), tz=timezone.utc)
        return dt.isoformat()
    except Exception:
        return epoch_secs


# ─── Main processing ────────────────────────────────────────────────

def process_db(db_path):
    """Process a single antigravity DB file."""
    filename = os.path.basename(db_path)
    cascade_id = os.path.splitext(filename)[0]
    
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    
    # Read trajectories
    cur.execute('SELECT * FROM trajectory_meta')
    trajectories = [dict(r) for r in cur.fetchall()]
    
    # Read steps
    cur.execute('SELECT * FROM steps ORDER BY idx')
    step_rows = [dict(r) for r in cur.fetchall()]
    
    # Read trajectory_metadata_blob
    cur.execute('SELECT * FROM trajectory_metadata_blob')
    meta_blobs = [dict(r) for r in cur.fetchall()]
    
    conn.close()
    
    results = []
    for traj in trajectories:
        traj_id = traj['trajectory_id']
        results.append(process_trajectory(traj, cascade_id, step_rows, meta_blobs))
    
    return results


def process_trajectory(traj, cascade_id, all_steps, meta_blobs):
    """Process one trajectory from a DB."""
    traj_id = traj['trajectory_id']
    traj_type = traj.get('trajectory_type', 0)
    source = traj.get('source', 0)
    
    # Filter steps for this trajectory (all steps belong to this traj in the DB)
    steps_data = []
    for row in all_steps:
        idx = row['idx']
        step_type = row['step_type']
        step_status = row['status']
        payload = row.get('step_payload')
        meta_bytes = row.get('metadata')
        has_sub = row.get('has_subtrajectory', 0)
        
        payload_bytes = bytes(payload) if payload else b''
        meta_field = bytes(meta_bytes) if meta_bytes else b''
        
        parsed_meta = _parse_meta(meta_field) if meta_field else {}
        
        parser = STEP_PARSERS.get(step_type)
        if parser and payload_bytes:
            try:
                _, parsed_content = parser(payload_bytes)
            except Exception as e:
                parsed_content = {'role': 'unknown', 'parts': [{'type': 'text', 'text': f'[parse error: {e}]'}]}
        else:
            parsed_content = {'role': 'unknown', 'parts': [{'type': 'text', 'text': f'[unhandled step type {step_type}]'}]}
        
        parsed_content['timestamp'] = parsed_meta.get('timestamp', 0)
        steps_data.append({
            'step_type': step_type,
            'status': step_status,
            'has_subtrajectory': has_sub,
            'meta': parsed_meta,
            'content': parsed_content,
        })
    
    # Build session
    session = build_session(traj_id, cascade_id, traj_type, source, [s['content'] for s in steps_data], meta_blobs)
    
    # Build messages and parts
    messages = {}
    parts_dict = {}
    for idx, sd in enumerate(steps_data):
        msg_id, msg, part_list = build_message_and_parts(
            idx, sd['step_type'], sd['status'], sd['meta'], sd['content'], traj_id
        )
        # Link to previous message
        if idx > 0:
            prev_ids = list(messages.keys())
            msg['parentID'] = prev_ids[-1]
        messages[msg_id] = msg
        parts_dict[msg_id] = part_list
    
    return {
        'trajectory_id': traj_id,
        'session': session,
        'messages': messages,
        'parts': parts_dict,
    }


# ─── Output ─────────────────────────────────────────────────────────

def write_output(traj_results, output_dir):
    """Write session, message, part files in Coach legacy format."""
    sessions_dir = os.path.join(output_dir, 'session', 'global')
    messages_root = os.path.join(output_dir, 'message')
    parts_root = os.path.join(output_dir, 'part')
    
    os.makedirs(sessions_dir, exist_ok=True)
    
    stats = {'sessions': 0, 'messages': 0, 'parts': 0}
    
    for tr in traj_results:
        traj_id = tr['trajectory_id']
        
        # Write session
        session_path = os.path.join(sessions_dir, f'{traj_id}.json')
        with open(session_path, 'w', encoding='utf-8') as f:
            json.dump(tr['session'], f, indent=2, ensure_ascii=False)
        stats['sessions'] += 1
        
        # Write messages
        msg_dir = os.path.join(messages_root, traj_id)
        os.makedirs(msg_dir, exist_ok=True)
        
        part_dir = os.path.join(parts_root, traj_id)
        os.makedirs(part_dir, exist_ok=True)
        
        for msg_id, msg in tr['messages'].items():
            msg_path = os.path.join(msg_dir, f'{msg_id}.json')
            with open(msg_path, 'w', encoding='utf-8') as f:
                json.dump(msg, f, indent=2, ensure_ascii=False)
            stats['messages'] += 1
            
            # Write parts
            for part in tr['parts'].get(msg_id, []):
                p_msg_dir = os.path.join(part_dir, msg_id)
                os.makedirs(p_msg_dir, exist_ok=True)
                part_path = os.path.join(p_msg_dir, f"{part['id']}.json")
                with open(part_path, 'w', encoding='utf-8') as f:
                    json.dump(part, f, indent=2, ensure_ascii=False)
                stats['parts'] += 1
    
    return stats


# ─── Entrypoint ─────────────────────────────────────────────────────

def main():
    antigravity_dir = ANTIGRAVITY_DIR
    output_dir = OUTPUT_DIR
    
    if not os.path.isdir(antigravity_dir):
        print(f'Error: antigravity conversations dir not found at {antigravity_dir}')
        print(f'Expected location: ~/.gemini/antigravity/conversations/')
        print('Searching alternatives...')
        alt = os.path.expanduser(r'~\.gemini\antigravity-ide\conversations')
        if os.path.isdir(alt):
            antigravity_dir = alt
            print(f'Found at: {alt}')
        else:
            sys.exit(1)
    
    db_files = sorted(glob(os.path.join(antigravity_dir, '*.db')))
    pb_files = sorted(glob(os.path.join(antigravity_dir, '*.pb')))
    
    print(f'Found {len(db_files)} SQLite DB files, {len(pb_files)} .pb files')
    print(f'Output: {output_dir}')
    
    all_results = []
    skipped = 0
    for db_path in db_files:
        fname = os.path.basename(db_path)
        try:
            results = process_db(db_path)
            if results:
                # Filter empty trajectories
                results = [r for r in results if r['session']['id']]
                all_results.extend(results)
                print(f'  {fname}: {len(results)} trajectories')
        except Exception as e:
            print(f'  {fname}: ERROR - {e}')
            skipped += 1
    
    if not all_results:
        print('No data processed.')
        return
    
    stats = write_output(all_results, output_dir)
    
    print(f'\nDone!')
    print(f'  Sessions: {stats["sessions"]}')
    print(f'  Messages: {stats["messages"]}')
    print(f'  Parts:    {stats["parts"]}')
    print(f'  Skipped:  {skipped} files')
    print(f'\nOutput directory: {output_dir}')
    print('Copy session/message/part to Coach\'s expected storage path.')


if __name__ == '__main__':
    main()
