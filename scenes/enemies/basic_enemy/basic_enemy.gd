extends CharacterBody2D

class_name BasicEnemy
@export var damage: int = 10
@export var base_speed: int = 100

@onready var attack_timer: Timer = $AttackTimer
@onready var target_update_timer: Timer = $TargetUpdateTimer
@onready var character_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State {
	IDLE,
	PURSUING,
	ATTACKING,
	RETREATING
}

var in_range: bool
var can_attack: bool = true
var stop_distance: float = 150
var attack_stop_distance: float = 100
var retreat_stop_distance: float = 50
var target_position: Vector2 = Vector2.INF
var health: Health
var retreating = false
var state: State = State.IDLE

func _ready() -> void:
	character_sprite.play("swimming")
	call_deferred("set_target")
	health = $Health

func _process(delta: float) -> void:
	match state:
		State.IDLE:
			set_target()
			state = State.PURSUING
		State.PURSUING:
			if target_position.distance_to(GameManager.submarine.position) > 200:
				set_target()
			if target_position.distance_to(position) < stop_distance:
				target_position = GameManager.submarine.position
				state = State.ATTACKING
		State.ATTACKING:
			pass
		State.RETREATING:
			if target_position.distance_to(position) < 10:
				set_target()
				state = State.PURSUING

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			pass
		State.PURSUING:
			pursue(delta)
		State.ATTACKING:
			pursue(delta)
		State.RETREATING:
			pursue(delta)
	# if target_position == Vector2.INF:
	#     return
	# if (target_position - position).length() < stop_distance:
	#     if retreating:
	#         print("I AM RETREATING")
	#         set_target()
	#         retreating = false
	#         stop_distance = attack_stop_distance
	#     return
	
	# var move_direction = (target_position - position).normalized()
	# velocity = move_direction * base_speed * delta * 100
	# move_and_slide()

func pursue(delta: float) -> void:
	var move_direction = (target_position - position).normalized()
	velocity = move_direction * base_speed * delta * 100
	if state == State.ATTACKING:
		velocity = velocity * 2
	move_and_slide()

func attack():
	#can_attack = false
	print("Attacked")
	attack_timer.start()
	var player_health: Health = GameManager.submarine.find_child("Health")
	player_health.take_damage(damage)
	
	target_position = position + _random_inside_unit_circle() * 300
	state = State.RETREATING

############ Helper functions ############

func _on_target_update_timer_timeout() -> void:
	#set_target()
	pass

func _on_attack_range_body_exited(_body: Node2D) -> void:
	#in_range = false
	pass

func _on_attack_range_body_entered(_body: Node2D) -> void:
	print("wololol")
	if state == State.ATTACKING:
		attack()

func _on_attack_timer_timeout() -> void:
	pass
	# can_attack = true
	# if in_range:
	#     attack()

func set_target() -> void:
	if not GameManager.submarine:
		return
	target_position = GameManager.submarine.position + Vector2(get_random_value_with_offset(50), get_random_value_with_offset(50))
	character_sprite.scale.x = int(target_position.x < position.x) * 2 - 1

func _on_health_health_depleted() -> void:
	queue_free()

func _random_inside_unit_circle() -> Vector2:
	var theta: float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())

func get_random_value_with_offset(base_value: float) -> float:
	# Randomly decide if we want a positive or negative value
	var is_positive = randf() > 0.5
	
	if is_positive:
		return base_value + randf() * base_value
	else:
		return -base_value - randf() * base_value
