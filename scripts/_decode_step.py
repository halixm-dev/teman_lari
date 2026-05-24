import sqlite3
from google.protobuf.internal import decoder

def decode_raw(data, indent=0, max_bytes=100000):
    prefix = '  ' * indent
    pos = 0
    while pos < len(data):
        if pos >= max_bytes:
            print(f'{prefix}... (truncated, {len(data) - pos} bytes remain)')
            break
        try:
            key, pos = decoder._DecodeVarint32(data, pos)
            field_num = key >> 3
            wire_type = key & 0x7
            label = f'{prefix}F{field_num} wt{wire_type}'
            
            if wire_type == 0:
                val, pos = decoder._DecodeVarint(data, pos)
                print(f'{label} = {val}')
            elif wire_type == 1:
                import struct
                val = struct.unpack('<Q', data[pos:pos+8])[0]
                pos += 8
                print(f'{label} fixed64={val}')
            elif wire_type == 2:
                length, pos = decoder._DecodeVarint32(data, pos)
                val = data[pos:pos+length]
                pos += length
                try:
                    text = val.decode('utf-8')
                    if len(text) < 200:
                        print(f'{label} str[{len(val)}]="{text}"')
                    else:
                        print(f'{label} str[{len(val)}]="{text[:100]}..."')
                except:
                    print(f'{label} bytes[{len(val)}]: {val[:48].hex()}...' if len(val) > 48 else f'{label} bytes[{len(val)}]: {val.hex()}')
                    if len(val) > 2 and len(val) < 100000:
                        decode_raw(val, indent + 2)
            elif wire_type == 5:
                import struct
                val = struct.unpack('<I', data[pos:pos+4])[0]
                pos += 4
                print(f'{label} fixed32={val}')
            else:
                print(f'{label} ??? wt={wire_type}')
                pos += 1
        except Exception as e:
            print(f'{prefix}Error at pos {pos}: {e}')
            break

db_path = r'C:\Users\M1n3r4I5\.gemini\antigravity\conversations\94757dab-4bdd-4ad6-af9b-edbc9bcd21d7.db'
conn = sqlite3.connect(db_path)
cur = conn.cursor()

# Overview
cur.execute('SELECT * FROM trajectory_meta')
print("=== TRAJECTORIES ===")
for r in cur.fetchall():
    print(f'  id={r[0]}, cascade={r[1]}, type={r[2]}, source={r[3]}')

# Step 0 payload
cur.execute('SELECT step_payload, metadata FROM steps WHERE idx = 0')
p, m = cur.fetchone()
print(f"\n=== STEP 0 PAYLOAD ({len(p)} bytes) ===")
try: decode_raw(p)
except Exception as e: print(f'Error: {e}')

print(f"\n=== STEP 0 METADATA ({len(m)} bytes) ===")
try: decode_raw(m)
except Exception as e: print(f'Error: {e}')

# Step 1 payload  
cur.execute('SELECT step_payload, metadata FROM steps WHERE idx = 1')
p, m = cur.fetchone()
print(f"\n=== STEP 1 PAYLOAD ({len(p)} bytes) ===")
try: decode_raw(p)
except Exception as e: print(f'Error: {e}')

print(f"\n=== STEP 1 METADATA ({len(m)} bytes) ===")
try: decode_raw(m)
except Exception as e: print(f'Error: {e}')

# Step 2 payload (type 9)
cur.execute('SELECT step_payload, metadata FROM steps WHERE idx = 2')
p, m = cur.fetchone()
print(f"\n=== STEP 2 PAYLOAD ({len(p)} bytes) ===")
try: decode_raw(p)
except Exception as e: print(f'Error: {e}')

conn.close()
