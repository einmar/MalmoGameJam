extends BaseStation

func control_station(delta) -> void:
	print("using pumpstation")
	if Input.is_action_pressed(_player.input_key("action")):
		GameManager.submarine.health.take_damage(-10.0 * delta)

	super(delta)
