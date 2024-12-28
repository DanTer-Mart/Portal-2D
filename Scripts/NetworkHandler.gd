extends Node

signal network_connected
signal network_disconnected
signal server_check_passed
signal server_check_failed

var network: StreamPeerTCP
var isConnected = false

func _ready() -> void:
	network = StreamPeerTCP.new()
	network.big_endian = false
	print("NetworkHandler is ready!")

func _process(_delta: float) -> void:
	network.poll()
	if network.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		if not isConnected:
			isConnected = true
			network_connected.emit()
		var avaliable_bytes = network.get_available_bytes()
		if avaliable_bytes > 0:
			var data = network.get_data(avaliable_bytes)
			var stream = ByteStream.new()
			stream.setBuffer(PackedByteArray(data[1]))
			
			var messageID = stream.getBuffer().decode_u32(0)
			var _messageLength = stream.getBuffer().decode_u32(4)
			match messageID:
				20000:
					var messageObj = TestPixMessage.new()
					messageObj.setBuffer(data[1].slice(8, avaliable_bytes))
					messageObj.decode()
					
					var results = messageObj.check()
					if results:
						server_check_passed.emit()
					else:
						server_check_failed.emit()
				_:
					print("Unknown message!")
	else:
		if isConnected:
			isConnected = false
			network_disconnected.emit()

func connectToServer(ip: String = "127.0.0.1", port: int = 2776):
	network.connect_to_host(ip, port)
