extends BaseStation

@export var submarine: Submarine 
func _ready() -> void:
    pass


func control_station(delta) -> void:
    var val = Input.get_axis(_player.input_key("up"), _player.input_key("down"))

    submarine.set_dir(val, false)	

    super(delta)
