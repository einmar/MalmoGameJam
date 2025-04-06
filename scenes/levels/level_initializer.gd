extends Node2D

var exit_map_node: Area2D
var enemy_spawn_timer: Timer

var spawn_offset = 10
var spawn_spacing = 50

############ Initialize ############
func _ready() -> void:
	Engine.time_scale = 1
	GameManager.reset_all_variables()
	GameManager.current_depth_resource = load("res://resources/0_depth.tres")
	call_deferred("level_setup")

func level_setup() -> void:
	enemy_spawn_timer = Timer.new()
	GameManager.scene_root_node = get_tree().current_scene
	self.add_child(enemy_spawn_timer)
	enemy_spawn_timer.timeout.connect(spawn_enemy)
	exit_map_node = GameManager.scene_root_node.find_child("exit_map")
	enemy_spawn_timer.start(GameManager.current_depth_resource.enemy_spawn_cooldown)
	GameManager.game_state_label = GameManager.scene_root_node.find_child("game_state_label")
	GameManager.canvas_modulate = GameManager.scene_root_node.find_child("CanvasModulate")
	GameManager.submarine.game_over.connect(game_over)
	exit_map_node.level_won.connect(level_won)

	for node in GameManager.scene_root_node.find_children("Player*", "", true):
		if node is Player:
			GameManager.players.append(node)
		
############ Level Logic ############

func level_won():
	Engine.time_scale = 0
	GameManager.canvas_modulate.hide()
	GameManager.game_state_label.show()
	GameManager.game_state_label.text = "GJ my dudes"

func game_over():
	Engine.time_scale = 0
	GameManager.canvas_modulate.hide()
	GameManager.game_state_label.show()
	GameManager.game_state_label.text = "Submarine sunk\nGAME OVER"

############ Enemy Logic ############

func spawn_enemy():
	var main_camera: Camera2D = GameManager.main_camera
	var camera_size = main_camera.get_viewport_rect().size * main_camera.zoom
	var camera_rect = [main_camera.get_screen_center_position().x - camera_size.x / 2,
					main_camera.get_screen_center_position().y - camera_size.y / 2,
					main_camera.get_screen_center_position().x + camera_size.x / 2,
					main_camera.get_screen_center_position().y + camera_size.y / 2]

	var spawn_offset_vector: Vector2 = Vector2.ZERO
	var spawn_position: Vector2 = Vector2.ZERO
	match randi_range(0,3):
		0: # left side of the screen
			spawn_offset_vector.y = spawn_spacing
			spawn_position = Vector2(camera_rect[0] - spawn_offset, randi_range(camera_rect[1], camera_rect[3]))
		1: # top side of the screen
			spawn_offset_vector.x = spawn_spacing
			spawn_position = Vector2(randf_range(camera_rect[0], camera_rect[2]), camera_rect[1] - spawn_offset)
		2: # right side of the screen
			spawn_offset_vector.y = spawn_spacing
			spawn_position = Vector2(camera_rect[2] + spawn_offset, randi_range(camera_rect[1], camera_rect[3]))
		3: # bottom side of the screen
			spawn_offset_vector.x = spawn_spacing
			spawn_position = Vector2(randf_range(camera_rect[0], camera_rect[2]), camera_rect[3] + spawn_offset)
	
	var enemy_index = GameManager.current_depth_resource.enemy_toughness
	var enemy_to_spawn: PackedScene = GameManager.current_depth_resource.enemy_scenes[enemy_index]
	for i in GameManager.current_depth_resource.enemy_spawn_amount:
		if not enemy_to_spawn:
			print("Enemy to spawn not found!")
			continue
		var spawned_enemy: CharacterBody2D = enemy_to_spawn.instantiate()
		self.add_child(spawned_enemy)
		spawned_enemy.position = spawn_position
		if i % 2 == 0: # even
			spawned_enemy.position += i*spawn_offset_vector
		else:
			spawned_enemy.position -= i*spawn_offset_vector
