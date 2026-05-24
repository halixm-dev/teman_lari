"""Directly test the bridge's parser functions on problematic DB."""
import sys
sys.path.insert(0, r'D:\Projects\teman_lari\scripts')

from bridge_antigravity_to_legacy import *

db = r'C:\Users\M1n3r4I5\.gemini\antigravity\conversations\030b5092-103c-454b-b1dc-20d3ff176973.db'

conn = sqlite3.connect(db)
conn.execute('PRAGMA wal_checkpoint(TRUNCATE)')
cur = conn.cursor()

try:
    cur.execute('SELECT * FROM trajectory_meta')
except sqlite3.OperationalError as e:
    print(f'Error accessing tables: {e}')
    cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
    print(f'Tables: {[r[0] for r in cur.fetchall()]}')
    conn.close()
    sys.exit(1)
for r in cur.fetchall():
    print(f'Trajectories: id={r[0]}, cascade={r[1]}, type={r[2]}, source={r[3]}')

cur.execute('SELECT idx, step_type, length(step_payload) FROM steps ORDER BY idx LIMIT 10')
print('\nSteps:')
for r in cur.fetchall():
    print(f'  idx={r[0]} type={r[1]} payload_len={r[2]}')

# Test parsing each step
cur.execute('SELECT idx, step_type, step_payload, metadata FROM steps ORDER BY idx LIMIT 5')
for r in cur.fetchall():
    idx, st, p, m = r
    print(f'\n=== Step {idx} (type={st}) ===')
    print(f'Payload len: {len(p) if p else 0}')
    
    meta_parsed = _parse_meta(bytes(m) if m else b'')
    print(f'Meta: {json.dumps(meta_parsed, default=str)[:200]}')
    
    parser = STEP_PARSERS.get(st)
    if parser and p:
        try:
            meta, content = parser(bytes(p))
            print(f'Content role: {content["role"]}')
            for part in content['parts']:
                print(f'  Part: type={part["type"]} text="{part.get("text", "")[:80]}"')
        except Exception as e:
            print(f'Parse error: {e}')
    else:
        print(f'No parser for type {st}')

conn.close()
