extends CharacterBody2D

@export var base_speed: int = 20

var target: Vector2 = Vector2.INF

func _ready() -> void:
	target = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if target == Vector2.INF:
		return
	var move_direction = (target - position).normalized()
	velocity = move_direction * base_speed * delta * 100
	move_and_slide()
