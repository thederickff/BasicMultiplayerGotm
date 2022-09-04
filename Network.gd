extends Node

const DEFAULT_PORT = 28960
const MAX_PLAYERS = 6

var serverPeer = null
var clientPeer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func create_server():
	serverPeer = NetworkedMultiplayerENet.new()
	serverPeer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(serverPeer)

func join_server():
	clientPeer = NetworkedMultiplayerENet.new()
	clientPeer.create_client("127.0.0.1", DEFAULT_PORT)
	get_tree().set_network_peer(clientPeer)

func _connected_to_server():
	print("connected to server")
	print("_connected_to_server from network")

func _server_disconnected():
	print("server disconnected")
	for child in Players.get_children():
		child.queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
