extends Node2D
class_name Light

@export var shot_cooldown: float = 0.5 # Cooldown time in seconds
@onready var point_light_2d: PointLight2D = $visual/PointLight2D

var rotation_normalization: float = 0.0
var last_shot : float = 0.0


func _ready() -> void:
	rotation_normalization = rotation_degrees

func rotate_light(rotation: float) -> void:
	# Rotate the gun by the specified amount
	rotation_degrees += rotation
	# Clamp the rotation to a certain range if needed
	rotation_degrees = clamp(rotation_degrees, -90 + rotation_normalization, 90 + rotation_normalization)
	# Update the gun's rotation
	rotation_degrees = rotation_degrees

func shoot() -> void:
	var time_now = Time.get_unix_time_from_system()
	if time_now - last_shot > shot_cooldown:
		last_shot = time_now
