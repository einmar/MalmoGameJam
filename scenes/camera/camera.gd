extends Camera2D

@export var target: Node2D
@export var follow_strength: float = 10 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, target.position, follow_strength/100.0)
