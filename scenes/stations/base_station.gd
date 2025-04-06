extends Node2D
class_name BaseStation
var _player: Player = null;
var _grabbed_control = false

@export var inactive_sprite: Sprite2D 
@export var active_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _player != null:
		control_station(delta)
		_grabbed_control = false
		return

	var close = false
	for player in GameManager.players:
		if player.global_position.distance_to(global_position) < 20:
			if active_sprite != null:
				active_sprite.visible = true
			close = true
	
	if not close:
		if inactive_sprite != null:
			inactive_sprite.visible = true
		if active_sprite != null:
			active_sprite.visible = false
		
func activate(player) -> bool:
	if _player != null:
		return false
		
	_player = player
	_grabbed_control = true
	return true
	
func control_station(delta) -> void:
	if _grabbed_control:
		on_enter()
		return

	if Input.is_action_just_pressed(_player.input_key("use")):
		on_leave()
		print("left")
		_player.leave_station()

func on_enter() -> void:
	pass

func on_leave() -> void:
	pass
