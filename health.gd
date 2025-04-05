extends Node2D
class_name Health

signal health_changed(health_value: float)
signal health_depleted

@export var max_health: float = 100.0
var health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

func take_damage(amount):
	health -= amount
	health = min(health, max_health)
	health = max(0.0, health)
	emit_signal("health_changed", health)
	
	if health <= 0:
		emit_signal("health_depleted")
