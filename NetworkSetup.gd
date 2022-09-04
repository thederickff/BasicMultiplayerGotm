extends Control

var PlayerScene = load("res://Player.tscn")

onready var multiplayerConfigure = $MultiplayerConfigure

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")

func _on_CreateServerButton_pressed():
	multiplayerConfigure.hide()
	Network.create_server()
	print("instance for me")
	instance_player(get_tree().get_network_unique_id())

func _on_JoinServerButton_pressed():
	multiplayerConfigure.hide()
	Network.join_server()

func _player_connected(id):
	print("instance for " + str(id))
	instance_player(id)

func _player_disconnected(id):
	print("Player " + str(id) + " disconnected")
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free() 
	
func _connected_to_server():
	yield(get_tree().create_timer(0.1), "timeout")
	print("instance for me waiting 0.1")
	instance_player(get_tree().get_network_unique_id())

func instance_player(id):
	var rand_location = Vector2(rand_range(0, 1920), rand_range(0, 1080))
	var player_instance = Global.instance_scene_at_location(PlayerScene, Players, rand_location)
	player_instance.name = str(id)
	player_instance.set_network_master(id)
