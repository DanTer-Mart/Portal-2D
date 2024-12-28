extends Node

class_name ByteStream

var buffer = PackedByteArray()
var offset = 0

func _init() -> void:
	buffer.resize(1024)

func writeBig(value: int) -> void:
	buffer.encode_s64(offset, value)
	offset += 8

func readBig() -> int:
	var retval = buffer.decode_s64(offset)
	offset += 8
	return retval

func writeInt(value: int) -> void:
	buffer.encode_s32(offset, value)
	offset += 4

func readInt() -> int:
	var retval = buffer.decode_s32(offset)
	offset += 4
	return retval

func writeFloat(value: float) -> void:
	buffer.encode_float(offset, value)
	offset += 4

func readFloat() -> float:
	var retval = buffer.decode_float(offset)
	offset += 4
	return retval

func writeShort(value: int) -> void:
	buffer.encode_s16(offset, value)
	offset += 2

func readShort() -> int:
	var retval = buffer.decode_s16(offset)
	offset += 2
	return retval

func writeString(value: String) -> void:
	var stringLen = value.length()
	var bytearray2 = PackedByteArray(value.to_utf8_buffer())
	buffer.encode_u32(offset, stringLen)
	offset += 4
	for i in range(stringLen):
		buffer.set(offset + i, bytearray2[i])
	offset += stringLen

func readString() -> String:
	var length: int = buffer.decode_u32(offset)
	offset += 4
	var string_bytes: PackedByteArray
	for i in range(length):
		string_bytes.append(buffer[offset + i])
	offset += length
	return string_bytes.get_string_from_utf8()

func writeVInt(value: int) -> void:
	while (value & 0xFFFFFF80) != 0:
		buffer.set(offset, (value & 0x7F) | 0x80)
		offset += 1
		value >>= 7
	buffer.set(offset, value & 0x7F)
	offset += 1

func readVInt() -> int:
	var value = 0
	var shift = 0
	var byte = 0

	while true:
		byte = buffer[offset]
		offset += 1
		value |= (byte & 0x7F) << shift
		if (byte & 0x80) == 0:
			break
		shift += 7

	return value

func seek(value: int) -> void:
	offset = value

func getOffset() -> int:
	return offset

func setBuffer(newBuffer: PackedByteArray) -> void:
	buffer = newBuffer

func getBuffer() -> PackedByteArray:
	return buffer

func resizeBuffer(value: int) -> void:
	buffer.resize(value)

func resetBuffer() -> void:
	buffer = PackedByteArray()
	buffer.resize(1024)
	seek(0)

# освобождает буфер от незанятых ячеек, чтобы не тратить сеть на передачу пустых данных
func clearEmpty() -> void:
	resizeBuffer(getOffset())
