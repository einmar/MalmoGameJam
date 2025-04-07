extends Node

var references = {}
var pause_menu: Control
var submarine: Submarine
var main_camera: Camera2D
var scene_root_node: Node2D
var game_state_label: Label
var game_paused: bool = false
var players: Array[Player] = []
var canvas_modulate: CanvasModulate
var current_depth_resource: DepthResource
var number_of_players: int = 1

func reset_all_variables() -> void:
	references = {}
	players = []
	pause_menu = null
	submarine = null
	main_camera = null
	scene_root_node = null
	game_state_label = null
	game_paused = false
	canvas_modulate = null
	current_depth_resource = null


############ Global references ############
func add(key: String, value):
	references[key] = value

func remove(key: String):
	if references.has(key):
		references.erase(key)
		return true
	return false

func clear_references():
	references.clear()

func fetch(key):
	if references.has(key):
		return references[key]
	return null
