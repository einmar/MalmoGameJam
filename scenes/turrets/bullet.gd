extends Node2D

# Speed of the bullet
@export var speed: float = 400.0
@export var damage: int = 10

var velocity: Vector2 = Vector2.ZERO

func _ready():
	velocity = (-Vector2.UP).rotated(rotation) * speed
	print(rotation)

func _process(delta: float):
	position += velocity * delta

func _on_body_entered(body: Node) -> void:
	if body is BasicEnemy:
		body.health.take_damage(damage)  # Deal damage to the enemy
		queue_free()  # Remove the bullet after hitting an enemy
	else:
		queue_free()  # Remove the bullet if it hits anything else

	visible = false
