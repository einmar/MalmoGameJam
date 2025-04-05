extends BaseStation

@export var _gun: Node2D
func _ready() -> void:
	pass # Replace with function body.

func control_station(delta) -> void:
	if Input.is_joy_known(0):
		pass
	else:
		var axis = Input.get_axis(_player.input_key("left"), _player.input_key("right"));
		print(axis)
	
	super(delta)