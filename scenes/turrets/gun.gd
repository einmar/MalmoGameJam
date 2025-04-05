extends Node2D
class_name Gun

@export var shot_cooldown: float = 0.5 # Cooldown time in seconds
@export var bullet_prefab: PackedScene # The bullet prefab to instantiate

var exit : Node2D
var last_shot : float = 0.0
var rotation_normalization: float = 0.0

func _ready() -> void:
	exit = find_child("exit")
	rotation_normalization = rotation_degrees

func _process(delta: float) -> void:
	# Called every frame. 'delta' is the elapsed time since the previous frame.
	pass

func rotate_gun(rotation: float) -> void:
	# Rotate the gun by the specified amount
	rotation_degrees += rotation
	# Clamp the rotation to a certain range if needed
	rotation_degrees = clamp(rotation_degrees, -45 + rotation_normalization, 45 + rotation_normalization)
	# Update the gun's rotation
	rotation_degrees = rotation_degrees

func shoot() -> void:
	var time_now = Time.get_unix_time_from_system()
	if time_now - last_shot > shot_cooldown:
		last_shot = time_now

		var bullet = bullet_prefab.instantiate()
		bullet.transform.origin = exit.global_position
		bullet.rotation = rotation
		get_tree().current_scene.add_child(bullet)
