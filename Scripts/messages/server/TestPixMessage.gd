extends PixedMessage

class_name TestPixMessage

var decoded_array: Array = []

func encode() -> void:
	pass

func decode() -> void:
	decoded_array.push_back(readShort())
	decoded_array.push_back(readInt())
	decoded_array.push_back(readString())
	
func check() -> bool:
	if decoded_array[0] == null or decoded_array[1] == null or decoded_array[2] == null:
		return false
	elif decoded_array[0] == 16 and decoded_array[1] == 32 and decoded_array[2] == "PixWar-fresh-server":
		return true
	else:
		return false

func getDecodedArray() -> Array:
	return decoded_array
