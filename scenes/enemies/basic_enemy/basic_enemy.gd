extends CharacterBody2D

@export var damage: int = 10
@export var base_speed: int = 100

@onready var attack_timer: Timer = $AttackTimer
@onready var target_update_timer: Timer = $TargetUpdateTimer
@onready var character_sprite: Sprite2D = $Sprite2D

var in_range: bool
var can_attack: bool = true
var stop_distance: float = 100
var target_position: Vector2 = Vector2.INF


func _ready() -> void:
	call_deferred("set_target")

func _physics_process(delta: float) -> void:
	if target_position == Vector2.INF:
		return
	if (target_position - position).length() < stop_distance:
		return
	
	var move_direction = (target_position - position).normalized()
	velocity = move_direction * base_speed * delta * 100
	move_and_slide()

func attack():
	can_attack = false
	attack_timer.start()
	var player_health: Health = GameManager.submarine.find_child("Health")
	player_health.take_damage(damage)

############ Helper functions ############

func _on_target_update_timer_timeout() -> void:
	set_target()

func _on_attack_range_body_exited(_body: Node2D) -> void:
	in_range = false

func _on_attack_range_body_entered(_body: Node2D) -> void:
	in_range = true
	if can_attack:
		attack()

func _on_attack_timer_timeout() -> void:
	can_attack = true
	if in_range:
		attack()

func set_target() -> void:
	if not GameManager.submarine:
		return
	target_position = GameManager.submarine.position
	character_sprite.flip_h = target_position.x > position.x

func _on_health_health_depleted() -> void:
	queue_free()
