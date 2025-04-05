extends BaseStation

var _gun_rotation_speed: float = 180.0 # degrees per second

@export var _guns: Array[Gun] = []
func _ready() -> void:
	pass # Replace with function body.

func control_station(delta) -> void:
	var axis = Input.get_axis(_player.input_key("left"), _player.input_key("right"));

	if axis != 0:
		for gun in _guns:
			gun.rotate_gun(-axis * _gun_rotation_speed * delta)


	for gun in _guns:
		if Input.is_action_pressed(_player.input_key("action")):
			gun.shoot()

	super(delta)
