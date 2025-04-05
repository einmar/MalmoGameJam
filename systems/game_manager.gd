extends Node


var references = {}
var player: Player
var submarine: Submarine
var main_camera: Camera2D
var scene_root_node: Node2D
var enemy_spawn_timer: Timer
var current_depth_resource: DepthResource


############ Initialize ############
func _ready() -> void:
    current_depth_resource = load("res://resources/0_depth.tres")
    call_deferred("level_setup")

func level_setup() -> void:
    enemy_spawn_timer = Timer.new()
    scene_root_node = get_tree().current_scene
    scene_root_node.add_child(enemy_spawn_timer)
    enemy_spawn_timer.timeout.connect(spawn_enemy)
    enemy_spawn_timer.start(current_depth_resource.enemy_spawn_cooldown)


############ Enemy Logic ############

func spawn_enemy():
    var spawn_side = randi_range(0,3)
    #var camera_size = player.get_viewport_rect().size * main_camera.zoom
    #var camera_rect = Rect2(main_camera.get_camera_screen_center() - camera_size / 2, camera_size)
    #print(camera_rect)



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
