from google.protobuf.internal import decoder
import sys

def decode_raw(data, indent=0, max_len=500):
    prefix = '  ' * indent
    pos = 0
    while pos < len(data) and pos < max_len:
        try:
            key, pos = decoder._DecodeVarint32(data, pos)
            field_num = key >> 3
            wire_type = key & 0x7
            print(f'{prefix}Field {field_num} (wire_type={wire_type}):', end=' ')
            
            if wire_type == 0:
                val, pos = decoder._DecodeVarint64(data, pos)
                print(f'varint: {val}')
            elif wire_type == 1:
                val = decoder._DecodeFixed64(data, pos)
                pos += 8
                print(f'fixed64: {val}')
            elif wire_type == 2:
                length, pos = decoder._DecodeVarint32(data, pos)
                val = data[pos:pos+length]
                pos += length
                try:
                    text = val.decode('utf-8')
                    if len(text) < 120:
                        print(f'string({len(val)}): "{text}"')
                    else:
                        print(f'string({len(val)}): "{text[:80]}..."')
                except:
                    print(f'bytes({len(val)}): {val[:40].hex()}...{val[-20:].hex()}' if len(val) > 60 else f'bytes({len(val)}): {val.hex()}')
                    if len(val) > 2 and len(val) < 10000:
                        print(f'{prefix}  -> nested:')
                        decode_raw(val, indent + 2)
            elif wire_type == 3:
                print('start_group')
            elif wire_type == 4:
                print('end_group')
            elif wire_type == 5:
                val = decoder._DecodeFixed32(data, pos)
                pos += 4
                print(f'fixed32: {val}')
            else:
                print(f'unknown wire_type: {wire_type}')
                break
        except Exception as e:
            print(f'{prefix}Error at pos {pos}: {e}')
            break
    if pos < len(data):
        print(f'{prefix}... (truncated, {len(data) - pos} bytes remaining)')

path = sys.argv[1]
with open(path, 'rb') as f:
    data = f.read()

print(f'=== {path} ({len(data)} bytes) ===')
print(f'First bytes hex: {data[:100].hex()}')
print()
decode_raw(data)
