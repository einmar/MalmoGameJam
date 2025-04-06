extends Area2D

signal level_won

var game_state_label: Label
var canvas_modulate: CanvasModulate

func _on_body_entered(body: Node2D) -> void:
	level_won.emit()


func _on_button_pressed() -> void:
	game_state_label = GameManager.scene_root_node.find_child("game_state_label")
	canvas_modulate = GameManager.scene_root_node.find_child("CanvasModulate")
	get_tree().reload_current_scene()
	game_state_label.text = ""
	game_state_label.hide()
	canvas_modulate.show()
