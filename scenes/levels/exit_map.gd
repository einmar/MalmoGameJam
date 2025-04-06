extends Area2D

signal level_won


func _on_body_entered(body: Node2D) -> void:
	level_won.emit()
