import sqlite3
from google.protobuf.internal import decoder

db = r'C:\Users\M1n3r4I5\.gemini\antigravity\conversations\94757dab-4bdd-4ad6-af9b-edbc9bcd21d7.db'

def _decode_raw_fields(data):
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
    for num, wt, val in _decode_raw_fields(data):
        if num == target_num:
            return val
    return None

def _get_str_field(data, field_num):
    v = _get_field(data, field_num)
    if isinstance(v, bytes):
        try:
            return v.decode('utf-8')
        except UnicodeDecodeError:
            pass
    return None

conn = sqlite3.connect(db)
cur = conn.cursor()

cur.execute('SELECT step_payload, metadata FROM steps WHERE idx = 0')
p, m = cur.fetchone()

# Test _decode_raw_fields
print('=== Raw fields of step 0 payload ===')
for num, wt, val in _decode_raw_fields(p):
    if isinstance(val, bytes):
        try:
            s = val.decode('utf-8')
            disp = f'str[{len(val)}]="{s[:100]}"'
        except:
            disp = f'bytes[{len(val)}]'
    else:
        disp = f'varint={val}'
    print(f'  F{num} wt{wt}: {disp}')

# Test _get_field for F19
print('\n=== _get_field(payload, 19) ===')
f19 = _get_field(p, 19)
if f19:
    print(f'Found: {len(f19)} bytes')
    print(f'First bytes hex: {f19[:60].hex()}')
    # Parse F19 fields
    for num, wt, val in _decode_raw_fields(f19):
        if isinstance(val, bytes):
            try:
                s = val.decode('utf-8')
                print(f'  F19.F{num}: str[{len(val)}]="{s[:100]}"')
            except:
                print(f'  F19.F{num}: bytes[{len(val)}]')
        else:
            print(f'  F19.F{num}: varint={val}')
else:
    print('Not found')

# Test _get_str_field for F19->F2
print('\n=== _get_str_field(f19, 2) ===')
s = _get_str_field(f19, 2)
if s:
    print(f'Found text: "{s[:100]}"')
else:
    print('Not found')

# Also check step 1
cur.execute('SELECT step_payload FROM steps WHERE idx = 1')
p = cur.fetchone()[0]
print('\n=== Raw fields of step 1 payload ===')
for num, wt, val in _decode_raw_fields(p):
    if isinstance(val, bytes):
        try:
            s = val.decode('utf-8')
            disp = f'str[{len(val)}]="{s[:80]}"'
        except:
            disp = f'bytes[{len(val)}]'
    else:
        disp = f'varint={val}'
    print(f'  F{num} wt{wt}: {disp}')

f20 = _get_field(p, 20)
if f20:
    print(f'\nF20 ({len(f20)} bytes):')
    for num, wt, val in _decode_raw_fields(f20):
        if isinstance(val, bytes):
            try:
                s = val.decode('utf-8')
                print(f'  F20.F{num}: str[{len(val)}]="{s[:100]}"')
            except:
                print(f'  F20.F{num}: bytes[{len(val)}]')
        else:
            print(f'  F20.F{num}: varint={val}')
else:
    print('F20 not found')

conn.close()
