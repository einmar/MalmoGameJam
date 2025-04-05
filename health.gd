extends Node2D
class_name Health

signal health_changed(health: int)
signal health_depleted

@export var max_health: int = 100
var health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

func take_damage(amount):
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
	
	if health == 0:
		emit_signal("health_depleted")
