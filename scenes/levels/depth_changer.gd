extends Area2D

@export var new_depth_resource: DepthResource

func _on_body_entered(body: Node2D) -> void:
	if not new_depth_resource:
		return
	GameManager.current_depth_resource = new_depth_resource
	print("changed_resource")
