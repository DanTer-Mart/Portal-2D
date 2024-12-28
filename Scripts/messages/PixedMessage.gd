extends ByteStream

class_name PixedMessage

var messageID = 0

func setMessageID(value: int) -> void:
	if value < 10000:
		push_warning("Message ID cannot be lower than 10000!")
		return
	
	if value > 29999:
		push_warning("Message ID cannot be greater than 29999!")
		return

	messageID = value

func getMessageID() -> int:
	return messageID

func encode() -> void:
	pass

func decode() -> void:
	pass

func execute() -> void:
	pass

# TODO: add more checks in code 
func encodeHeader() -> bool:
	var headerBuffer = PackedByteArray()
	headerBuffer.resize(8)
	headerBuffer.encode_u32(0, getMessageID())
	headerBuffer.encdoe_u32(4, getOffset())

	var finalBuffer = PackedByteArray()
	finalBuffer.append_array(headerBuffer)
	finalBuffer.append_array(getBuffer())
	setBuffer(finalBuffer)
	return true

func send(network: StreamPeerTCP):
	var encodeHeaderResult = encodeHeader()
	if encodeHeaderResult == true:
		network.put_data(getBuffer())
	else:
		push_warning("Failed to send!")