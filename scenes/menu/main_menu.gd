extends Control

@export var level_scene: PackedScene

func _on_button_pressed() -> void:
    var tree: SceneTree = get_tree()
    tree.change_scene_to_packed(level_scene)

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("player1_use"):
        _on_button_pressed()


func _on_option_button_item_selected(index: int) -> void:
    GameManager.number_of_players = index + 1
