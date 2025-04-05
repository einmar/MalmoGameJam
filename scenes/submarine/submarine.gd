extends CharacterBody2D

class_name Submarine

signal water_level_changed(water_level: float)

@export var max_vertical_speed: float = 100.0
@export var max_horizontal_speed: float = 100.0


var buoyancy: float = 980.0
var speed: float = 70.0
var player_index: int = 1
var is_steering: bool = false
var timer: float = 0.0
var turbulence: float = 1.0 
var tilt_damping: float = 10.0
var direction: Vector2 = Vector2.ZERO
var water_level: float = 0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var stations: Array[BaseStation] = []
func _ready() -> void:
	GameManager.submarine = self
	for child in get_children():
		if child is BaseStation:
			stations.append(child)


func _physics_process(delta: float) -> void:
	timer += delta
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(get_gravity().x, get_gravity().y - buoyancy) * delta
		
	velocity += direction * speed * delta
	velocity.x = clamp(velocity.x, -max_vertical_speed, max_vertical_speed)
	rotation = deg_to_rad(velocity.x / tilt_damping) + sin(timer * turbulence)/tilt_damping

	velocity.y =  clamp(velocity.y, -max_vertical_speed, max_vertical_speed)
	velocity.x =  clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	move_and_slide()
	direction = Vector2.ZERO
	
	# For debug
	if Input.is_action_just_pressed("ui_home"):
		$"Health".take_damage(10)
	
func set_dir(val, is_x):
	if is_x:
		direction.x = val
	else:
		direction.y = val

func get_station(pos: Vector2, radius: float) -> BaseStation:
	
	var closest_station = null
	var d: float = INF
	for station in stations:
		var dist: float = pos.distance_to(station.transform.get_origin())
		if dist < radius and dist < d:
			d = dist
			closest_station = station
			
	return closest_station

func set_water_level(level):
	water_level = level
	print(water_level)
	water_level_changed.emit(water_level)

func _on_health_health_changed(health: int) -> void:
	print("Took damage, current health:", health)
	set_water_level(1.0 - float(health)/100.0)


func _on_health_health_depleted() -> void:
	print("Submarine sunk, GAME OVER")
