extends CharacterBody2D

class_name Player

@export var player_index: int = 1

const SPEED = 70.0
const JUMP_VELOCITY = -300.0

var _active_station: BaseStation = null
func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta
    
    if _active_station == null:
        # Handle jump.
        if Input.is_action_just_pressed("player{i}_jump".format({"i":player_index})) and is_on_floor():
            velocity.y = JUMP_VELOCITY

        # Get the input direction and handle the movement/deceleration.
        # As good practice, you should replace UI actions with custom gameplay actions.
        var direction := Input.get_axis(
            "player{i}_left".format({"i":player_index}), 
            "player{i}_right".format({"i":player_index}),
        )
        if direction:
            velocity.x = direction * SPEED
        else:
            velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    
func _process(delta: float) -> void: 
    var closest_station = check_for_stations() 
    if closest_station == null: 
        return
    
    if Input.is_action_just_pressed(input_key("use")):
        if closest_station.activate(self):
            _active_station = closest_station;
    
    
func input_key(key) -> String:
    return "player%s_%s" % [player_index, key]
    
func check_for_stations() -> BaseStation:
    var sub = find_parent("Submarine")
    return sub.get_station(position, 1000.0)

func leave_station() -> void:
    _active_station._player = null
    _active_station = null
