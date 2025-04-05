extends BaseStation

@export var _lights: Array[Light] = []
@export var light_energy_on: float = 4.0
@export var light_energy_off: float = 1.0

var _light_rotation_speed: float = 180.0 # degrees per second

func _ready() -> void:
	pass # Replace with function body.

func control_station(delta) -> void:
	var axis = Input.get_axis(_player.input_key("left"), _player.input_key("right"));

	if axis != 0:
		for light in _lights:
			light.rotate_light(-axis * _light_rotation_speed * delta)


	for light in _lights:
		if Input.is_action_pressed(_player.input_key("action")):
			light.shoot()

	super(delta)

func on_enter() -> void:
	for light in _lights:
		light.point_light_2d.energy = light_energy_on

func on_leave() -> void:
	for light in _lights:
		light.point_light_2d.energy = light_energy_off
