import sqlite3
from google.protobuf.internal import decoder

db_path = r'C:\Users\M1n3r4I5\.gemini\antigravity\conversations\5f4c6e0d-4c76-4f23-9913-c4be736fddb0.db'
conn = sqlite3.connect(db_path)
cur = conn.cursor()

def decode_raw(data, max_len=2000, indent=''):
    pos = 0
    while pos < len(data) and pos < max_len:
        key, pos = decoder._DecodeVarint32(data, pos)
        fn = key >> 3
        wt = key & 0x7
        if wt == 0:
            v, pos = decoder._DecodeVarint(data, pos)
            print(f'{indent}F{fn}: varint = {v}')
        elif wt == 2:
            l, pos = decoder._DecodeVarint32(data, pos)
            v = data[pos:pos+l]
            pos += l
            try:
                txt = v.decode('utf-8')
                if len(txt) > 200:
                    print(f'{indent}F{fn}: str({len(txt)}) = "{txt[:200]}..."')
                else:
                    print(f'{indent}F{fn}: str = "{txt}"')
            except:
                if len(v) < 100:
                    print(f'{indent}F{fn}: bytes = {v.hex()}')
                else:
                    print(f'{indent}F{fn}: bytes({len(v)}) = {v[:40].hex()}...')
                    # Try nested decode
                    if len(v) > 2:
                        decode_raw(v, max_len, indent + '  ')
        elif wt == 5:
            import struct
            v = struct.unpack('<I', data[pos:pos+4])[0]
            pos += 4
            print(f'{indent}F{fn}: fixed32 = {v}')
        elif wt == 1:
            import struct
            v = struct.unpack('<Q', data[pos:pos+8])[0]
            pos += 8
            print(f'{indent}F{fn}: fixed64 = {v}')
        else:
            print(f'{indent}F{fn}: wt={wt} ???')
            pos += 1

# Step 2 (type 90) - F103 content
cur.execute('SELECT step_payload FROM steps WHERE idx = 2')
p = bytes(cur.fetchone()[0])
pos = 0
while pos < len(p):
    key, pos = decoder._DecodeVarint32(p, pos)
    fn = key >> 3
    wt = key & 0x7
    if fn == 103 and wt == 2:
        l, pos = decoder._DecodeVarint32(p, pos)
        f103 = p[pos:pos+l]
        print(f'=== Step 2 (type 90) F103 ({len(f103)} bytes) ===')
        decode_raw(f103)
        break
    elif wt == 0:
        _, pos = decoder._DecodeVarint(p, pos)
    elif wt == 2:
        l, pos = decoder._DecodeVarint32(p, pos)
        pos += l

# Step 4 (type 21) - F5 content (large blob)
cur.execute('SELECT step_payload FROM steps WHERE idx = 4')
p = bytes(cur.fetchone()[0])
pos = 0
while pos < len(p):
    key, pos = decoder._DecodeVarint32(p, pos)
    fn = key >> 3
    wt = key & 0x7
    if fn == 5 and wt == 2:
        l, pos = decoder._DecodeVarint32(p, pos)
        f5 = p[pos:pos+l]
        print(f'\n=== Step 4 (type 21) F5 ({len(f5)} bytes) ===')
        decode_raw(f5, 3000)
        break
    elif wt == 0:
        _, pos = decoder._DecodeVarint(p, pos)
    elif wt == 2:
        l, pos = decoder._DecodeVarint32(p, pos)
        pos += l

# Also check what step 15 (type 15) F20→F1 contains
cur.execute('SELECT step_payload FROM steps WHERE idx = 3')
p = bytes(cur.fetchone()[0])
pos = 0
while pos < len(p):
    key, pos = decoder._DecodeVarint32(p, pos)
    fn = key >> 3
    wt = key & 0x7
    if fn == 20 and wt == 2:
        l, pos = decoder._DecodeVarint32(p, pos)
        f20 = p[pos:pos+l]
        print(f'\n=== Step 3 (type 15) F20 fields ===')
        decode_raw(f20, 3000)
        break
    elif wt == 0:
        _, pos = decoder._DecodeVarint(p, pos)
    elif wt == 2:
        l, pos = decoder._DecodeVarint32(p, pos)
        pos += l

conn.close()
