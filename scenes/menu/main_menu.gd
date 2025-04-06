extends Control

@export var level_scene: PackedScene

func _on_button_pressed() -> void:
	var tree: SceneTree = get_tree()
	tree.change_scene_to_packed(level_scene)
	tree.root.child_entered_tree.connect(
	(func (scene: Node2D) -> void:
		GameManager.call_deferred("level_setup")
	),
	CONNECT_ONE_SHOT
	)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("player1_use"):
		_on_button_pressed()
