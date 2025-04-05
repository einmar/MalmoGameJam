extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    scale = Vector2(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_submarine_water_level_changed(water_level: float) -> void:
    scale = Vector2(water_level,1)
