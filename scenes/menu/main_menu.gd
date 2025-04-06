extends Control

@export var level_scene: PackedScene

func _on_button_pressed() -> void:
	var tree: SceneTree = get_tree()
	tree.change_scene_to_packed(level_scene)
	tree.root.child_entered_tree.connect(
	(func (scene: Node2D) -> void:
		GameManager.level_setup()
	),
	CONNECT_ONE_SHOT
	)
