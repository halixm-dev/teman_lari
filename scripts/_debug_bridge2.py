"""Test bridge output for known-working DB."""
import sys
sys.path.insert(0, r'D:\Projects\teman_lari\scripts')
from bridge_antigravity_to_legacy import *
import json, os

db = r'C:\Users\M1n3r4I5\.gemini\antigravity\conversations\94757dab-4bdd-4ad6-af9b-edbc9bcd21d7.db'

results = process_db(db)
for tr in results:
    traj_id = tr['trajectory_id']
    session = tr['session']
    print(f'Session: {traj_id}')
    print(f'  title: "{session["title"]}"')
    print(f'  created: {session["time"]["created"]}')
    msgs = list(tr['messages'].items())
    print(f'  messages: {len(msgs)}')
    for mid, msg in msgs[:5]:
        role = msg['role']
        st = msg.get('stepType', '?')
        parts = tr['parts'].get(mid, [])
        text = parts[0].get('text', '') if parts else ''
        print(f'    msg {mid[:12]}... role={role} stepType={st} text="{text[:60]}"')
