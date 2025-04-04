extends RigidBody2D

@export var player: int = 0

func _physics_process(delta: float) -> void:
	var steering = Input.get_joy_axis(player,JOY_AXIS_LEFT_X)
	var acceleration = Input.get_joy_axis(player,JOY_AXIS_LEFT_Y)
	print(steering)
