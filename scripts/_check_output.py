import json, os

d = r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach-from-antigravity\session\global'
files = sorted(os.listdir(d))
print(f'{len(files)} sessions')
for f in files[:5]:
    with open(os.path.join(d, f), encoding='utf-8') as fh:
        s = json.load(fh)
    title = s.get('title', '')
    print(f'  {f}: title="{title}"')

msg_dir = r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach-from-antigravity\message'
sids = sorted(os.listdir(msg_dir))
if sids:
    sid = sids[0]
    msgs = sorted(os.listdir(os.path.join(msg_dir, sid)))
    print(f'\nSession {sid}: {len(msgs)} messages')
    for m in msgs[:5]:
        with open(os.path.join(msg_dir, sid, m), encoding='utf-8') as fh:
            msg = json.load(fh)
        role = msg['role']
        st = msg.get('stepType', '?')
        # Show first part text snippet
        part_dir = r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach-from-antigravity\part'
        pmd = os.path.join(part_dir, sid, m)
        first_text = ''
        if os.path.isdir(pmd):
            pfiles = sorted(os.listdir(pmd))
            if pfiles:
                with open(os.path.join(pmd, pfiles[0]), encoding='utf-8') as fh:
                    p = json.load(fh)
                first_text = p.get('text', '')
        print(f'  msg[{m[:12]}...] role={role} stepType={st} text="{first_text[:80]}"')
