import json, os

# Check both output dirs
dirs = [
    ('OpenCode bridge', r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach'),
    ('Antigravity bridge', r'C:\Users\M1n3r4I5\.local\share\opencode\legacy-for-coach-from-antigravity'),
]

for label, d in dirs:
    sd = os.path.join(d, 'session', 'global')
    if os.path.isdir(sd):
        files = os.listdir(sd)
        print(f'{label}: {len(files)} sessions')
        for f in sorted(files)[:3]:
            with open(os.path.join(sd, f), encoding='utf-8') as fh:
                s = json.load(fh)
            title = s.get('title', '')
            created = s['time']['created']
            print(f'  {f}: title="{title[:60]}" created={created}')
    else:
        print(f'{label}: no output dir')
