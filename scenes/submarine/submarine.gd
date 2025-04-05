extends CharacterBody2D

class_name Submarine


var buoyancy: float = 980.0
var speed: float = 70.0
var player_index: int = 1
var is_steering: bool = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	GameManager.submarine = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(get_gravity().x, get_gravity().y - buoyancy) * delta
	if Input.is_action_just_pressed("player{i}_primary".format({"i":player_index})):
		is_steering = not is_steering
	if is_steering:
		var direction:= Vector2(Input.get_axis(
				"player{i}_left".format({"i":player_index}), 
				"player{i}_right".format({"i":player_index}),
			),
			Input.get_axis(
				"player{i}_up".format({"i":player_index}), 
				"player{i}_down".format({"i":player_index}),
			),
		)
		
		velocity += direction * speed * delta

	move_and_slide()
