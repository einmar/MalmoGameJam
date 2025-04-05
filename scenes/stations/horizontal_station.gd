extends BaseStation

@export var submarine: Submarine
func _ready() -> void:
	pass


func control_station(delta) -> void:
	var val = Input.get_axis(_player.input_key("left"), _player.input_key("right"))

	submarine.set_dir(val, true)

	super(delta)
