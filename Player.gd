extends KinematicBody2D

const SPEED = 300
var velocity = Vector2()

onready var tween = $Tween

puppet var puppet_position = Vector2() setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0

func _physics_process(delta):
	if is_network_master():
		var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var y_input = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		velocity = Vector2(x_input, y_input).normalized()
		move_and_slide(velocity * SPEED)
		look_at(get_global_mouse_position())
	else:
		global_rotation = lerp(global_rotation, puppet_rotation, delta * 8)
		
		if not tween.is_active():
			move_and_slide(puppet_velocity * SPEED)

func _on_NetworkTickerRate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_rotation", global_rotation)

func puppet_position_set(new_value: Vector2):
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()

