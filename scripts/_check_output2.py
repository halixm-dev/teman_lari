import json, os

d = r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach-from-antigravity\session\global'
files = sorted(os.listdir(d))
print(f'{len(files)} sessions')

with_titles = 0
for f in files:
    with open(os.path.join(d, f), encoding='utf-8') as fh:
        s = json.load(fh)
    title = s.get('title', '')
    if title:
        with_titles += 1
        if with_titles <= 5:
            print(f'  {f}: title="{title[:60].encode("ascii", "replace").decode("ascii")}"')
    else:
        if files.index(f) < 5:
            print(f'  {f}: NO TITLE')

print(f'\nSessions with titles: {with_titles}/{len(files)}')

# Check message roles
msg_dir = r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach-from-antigravity\message'
sids = sorted(os.listdir(msg_dir))
if sids:
    sid = sids[0]
    msgs = sorted(os.listdir(os.path.join(msg_dir, sid)))
    print(f'\nSession {sid}: {len(msgs)} messages')
    roles = {}
    for m in msgs[:10]:
        with open(os.path.join(msg_dir, sid, m), encoding='utf-8') as fh:
            msg = json.load(fh)
        role = msg['role']
        st = msg.get('stepType', '?')
        roles[st] = role
        # Get first part text
        part_dir = r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach-from-antigravity\part'
        pmd = os.path.join(part_dir, sid, m)
        first_text = ''
        if os.path.isdir(pmd):
            pfiles = sorted(os.listdir(pmd))
            if pfiles:
                with open(os.path.join(pmd, pfiles[0]), encoding='utf-8') as fh:
                    p = json.load(fh)
                first_text = p.get('text', '')
        print(f'  msg[{m[:12]}...] role={role} stepType={st} text="{first_text[:60]}"')
    
    print('\nStep type mappings:')
    for st in sorted(roles.keys()):
        print(f'  {st} -> {roles[st]}')
