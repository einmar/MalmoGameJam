extends CharacterBody2D

class_name Player

@export var player_index: int = 1
@export var sprite_animated: AnimatedSprite2D

const SPEED = 70.0
const JUMP_VELOCITY = -300.0

var _active_station: BaseStation = null
var in_water: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if _active_station == null:
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
	animate()
	
	move_and_slide()

func animate() -> void:
	if velocity.x < 0:
		sprite_animated.flip_h = true
	elif velocity.x > 0:
		sprite_animated.flip_h = false

	var idle = is_on_floor() and is_zero_approx(velocity.x)
	var swim_idle = in_water and is_zero_approx(velocity.x)
	var jumping = Input.is_action_just_pressed("player{i}_jump".format({"i":player_index})) and is_on_floor()
	if in_water:
		if swim_idle:
			sprite_animated.play("swim_idle")
		else:
			sprite_animated.play("swim")
	else:
		if jumping:
			sprite_animated.play("jump_start")
		elif idle:
			sprite_animated.play("idle")
		elif is_on_floor():
			sprite_animated.play("walk")
	

func _process(delta: float) -> void: 
	var closest_station = check_for_stations() 
	if closest_station == null: 
		return
	
	if Input.is_action_just_pressed(input_key("use")):
		if closest_station.activate(self):
			_active_station = closest_station;
	
	
func input_key(key) -> String:
	return "player%s_%s" % [player_index, key]
	
func check_for_stations() -> BaseStation:
	var sub = find_parent("Submarine")
	return sub.get_station(position, 1000.0)

func leave_station() -> void:
	_active_station._player = null
	_active_station = null


func _on_player_animated_sprite_2d_animation_finished() -> void:
	if sprite_animated.animation == "jump_start":
		sprite_animated.play("jump")
