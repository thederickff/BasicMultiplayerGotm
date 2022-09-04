extends Node

func instance_scene(scene: PackedScene, parent: Node) -> Node:
	var scene_instance = scene.instance()
	parent.add_child(scene_instance)
	return scene_instance

func instance_scene_at_location(scene: PackedScene, parent: Node, location: Vector2) -> Node2D:
	var scene_instance = instance_scene(scene, parent)
	scene_instance.global_position = location
	return scene_instance
