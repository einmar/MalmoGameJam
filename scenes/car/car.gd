extends RigidBody2D
# Loosely based on https://kidscancode.org/godot_recipes/3.x/2d/car_steering/


@export var player: int = 0
@export var steering_force: float = 200000
@export var acceleration: float = 2000
@export var max_speed: float = 400

var steering: float = 0
var speed: float = 0

func _ready() -> void:
	GameManager.player = self



func _physics_process(delta: float) -> void:
	#print(get_last_motion()) stuped
	#velocity = get_last_motion()
	var steering_input: float 
	var acceleration_input: float
	if Input.is_joy_known(0):
		steering_input = Input.get_joy_axis(player,JOY_AXIS_LEFT_X)
		acceleration_input = Input.get_joy_axis(player,JOY_AXIS_LEFT_Y)
	else:
		steering_input = Input.get_axis("player1_left","player1_right")
		acceleration_input = Input.get_axis("player1_up","player1_down")
	#steering = steering_input * deg_to_rad(steering)
	#rotate(steering_input * steering_force * delta)
	apply_torque(steering_input * steering_force * delta)
	#speed += acceleration
	apply_central_force(transform.y * (acceleration_input * acceleration * delta))
	#velocity += transform.y * (acceleration * 40 * delta)
	#move_and_slide()
	#smoothstep(speed,max_speed, )

func attacked(damage:int):
	print("Damage taken: ", damage)
