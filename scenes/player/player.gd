extends CharacterBody2D

class_name Player

@export var player_index: int = 1

const SPEED = 70.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player{i}_jump".format({"i":player_index})) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(
		"player{i}_left".format({"i":player_index}), 
		"player{i}_right".format({"i":player_index}),
	)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
