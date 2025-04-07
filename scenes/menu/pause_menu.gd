extends Control

func _ready() -> void:
	GameManager.pause_menu = self

func pause():
	self.show()
	Engine.time_scale = 0
	GameManager.canvas_modulate.hide()
	GameManager.game_paused = !GameManager.game_paused

func _on_resume_pressed() -> void:
	self.hide()
	Engine.time_scale = 1
	GameManager.canvas_modulate.show()
	GameManager.game_paused = !GameManager.game_paused

func _on_flee_pressed() -> void:
	get_tree().quit()
