extends CharacterBody2D

class_name Submarine

@export var max_vertical_speed: float = 300.0
var buoyancy: float = 980.0
var speed: float = 70.0
var player_index: int = 1
var is_steering: bool = false
var timer: float = 0.0
var turbulence: float = 1.0 
var tilt_damping: float = 10.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var stations: Array[BaseStation] = []
func _ready() -> void:
	GameManager.submarine = self
	for child in get_children():
		if child is BaseStation:
			stations.append(child)
			
	print(stations)

func _physics_process(delta: float) -> void:
	timer += delta
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(get_gravity().x, get_gravity().y - buoyancy) * delta
	if Input.is_action_just_pressed("player{i}_use".format({"i":player_index})):
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
	velocity.x = clamp(velocity.x, -max_vertical_speed, max_vertical_speed)
	rotation = deg_to_rad(velocity.x / tilt_damping) + sin(timer * turbulence)/tilt_damping


	move_and_slide()
	
func get_station(pos: Vector2, radius: float) -> BaseStation:
	
	var closest_station = null
	var d: float = INF
	for station in stations:
		var dist: float = pos.distance_to(station.transform.get_origin())
		if dist < radius and dist < d:
			d = dist
			closest_station = station
			
	return closest_station

	
