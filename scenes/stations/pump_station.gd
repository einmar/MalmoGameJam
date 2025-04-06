extends BaseStation

@export var pump_rate: float = 20.0


func control_station(delta) -> void:
	if Input.is_action_pressed(_player.input_key("action")):
		GameManager.submarine.health.take_damage(-pump_rate * delta)

	super(delta)
