import sqlite3
from google.protobuf.internal import decoder

db = r'C:\Users\M1n3r4I5\.gemini\antigravity\conversations\94757dab-4bdd-4ad6-af9b-edbc9bcd21d7.db'

conn = sqlite3.connect(db)
cur = conn.cursor()

cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = [t[0] for t in cur.fetchall()]
print(f'Tables: {tables}')

# Get step 0 
cur.execute('SELECT step_payload, metadata FROM steps WHERE idx = 0')
p, m = cur.fetchone()

print(f'Payload len: {len(p)}')
print(f'Meta len: {len(m)}')
print(f'Payload first 60 hex: {p[:60].hex()}')

# Find F19
pos = 0
found = {}
while pos < len(p):
    key, pos = decoder._DecodeVarint32(p, pos)
    field_num = key >> 3
    wire_type = key & 0x7
    if wire_type == 2:
        length, pos = decoder._DecodeVarint32(p, pos)
        val = p[pos:pos+length]
        pos += length
        try:
            s = val.decode('utf-8')
            found[field_num] = f'str[{len(val)}]="{s[:80]}..."'
        except:
            continue

print(f'Fields in payload:')
for fn in sorted(found.keys()):
    print(f'  F{fn}: {found[fn]}')

# Now check step 1 (type 15)
cur.execute('SELECT step_payload, metadata FROM steps WHERE idx = 1')
p, m = cur.fetchone()
print(f'\nStep 1 payload len: {len(p)}')

pos = 0
found = {}
while pos < len(p):
    key, pos = decoder._DecodeVarint32(p, pos)
    field_num = key >> 3
    wire_type = key & 0x7
    if wire_type == 2:
        length, pos = decoder._DecodeVarint32(p, pos)
        val = p[pos:pos+length]
        pos += length
        try:
            s = val.decode('utf-8')
            found[field_num] = f'str[{len(val)}]="{s[:80]}..."'
        except:
            continue

print(f'Fields in payload:')
for fn in sorted(found.keys()):
    print(f'  F{fn}: {found[fn]}')

# Check if F20 exists and what's in it
if 20 in found:
    pos = 0
    while pos < len(p):
        key, pos = decoder._DecodeVarint32(p, pos)
        field_num = key >> 3
        wire_type = key & 0x7
        if field_num == 20 and wire_type == 2:
            length, pos = decoder._DecodeVarint32(p, pos)
            val = p[pos:pos+length]
            pos += length
            print(f'\nF20 content ({len(val)} bytes):')
            p2 = 0
            while p2 < len(val):
                k2, p2 = decoder._DecodeVarint32(val, p2)
                fn2 = k2 >> 3
                wt2 = k2 & 0x7
                if wt2 == 2:
                    l2, p2 = decoder._DecodeVarint32(val, p2)
                    v2 = val[p2:p2+l2]
                    try:
                        s = v2.decode('utf-8')
                        print(f'  F20.F{fn2} str[{l2}]="{s[:100]}"')
                    except:
                        pass
                    p2 += l2
                elif wt2 == 0:
                    vv, p2 = decoder._DecodeVarint(val, p2)
            break
        elif wire_type == 2:
            length, pos = decoder._DecodeVarint32(p, pos)
            pos += length
        elif wire_type == 0:
            _, pos = decoder._DecodeVarint(p, pos)
        else:
            break

conn.close()
