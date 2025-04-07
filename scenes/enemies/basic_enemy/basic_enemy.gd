extends CharacterBody2D

class_name BasicEnemy
@export var damage: int = 10
@export var base_speed: int = 100
@export var glowy_bits: Sprite2D

@onready var attack_timer: Timer = $AttackTimer
@onready var target_update_timer: Timer = $TargetUpdateTimer
@onready var character_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State {
	IDLE,
	PURSUING,
	PREPARING,
	ATTACKING,
	RETREATING,
	DEAD
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
var prep_timer: float
var prep_wait: float

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
			if target_position.distance_to(GameManager.submarine.position) > 250:
				set_target()
			if target_position.distance_to(position) < stop_distance:
				state = State.PREPARING
				prep_timer = Time.get_unix_time_from_system()
				prep_wait = randf_range(0.0, 0.2)
		State.PREPARING:
			if prep_timer + prep_wait < Time.get_unix_time_from_system():
				state = State.ATTACKING
				target_position = GameManager.submarine.position + _random_inside_unit_circle() * 30
		State.ATTACKING:
			if target_position.distance_to(GameManager.submarine.position) > 150:
				state = State.IDLE
		State.RETREATING:
			if target_position.distance_to(position) < 10:
				state = State.IDLE
		State.DEAD:
			pass

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			pass
		State.PURSUING:
			pursue(delta)
		State.PREPARING:
			pass
		State.ATTACKING:
			pursue(delta)
		State.RETREATING:
			pursue(delta)
		State.DEAD:
			sink(delta)
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
	if state == State.RETREATING:
		velocity = velocity * 1.5
	move_and_slide()

func sink(delta: float) -> void:
	velocity += (get_gravity() * delta) / 4.0

	move_and_slide()


func attack():
	#can_attack = false
	print("Attacked")
	attack_timer.start()
	var player_health: Health = GameManager.submarine.find_child("Health")
	player_health.take_damage(damage)
	
	target_position = position + Vector2(get_random_value_with_offset(200), get_random_value_with_offset(200)) + _random_inside_unit_circle() * 600
	state = State.RETREATING

############ Helper functions ############

func _on_target_update_timer_timeout() -> void:
	#set_target()
	pass

func _on_attack_range_body_exited(_body: Node2D) -> void:
	#in_range = false
	pass

func _on_attack_range_body_entered(_body: Node2D) -> void:
	if state == State.DEAD:
		return

	if state == State.ATTACKING:
		attack()
	else:
		target_position = position + Vector2(get_random_value_with_offset(200), get_random_value_with_offset(200)) + _random_inside_unit_circle() * 600
		state = State.RETREATING

func _on_attack_timer_timeout() -> void:
	pass
	# can_attack = true
	# if in_range:
	#     attack()

func set_target() -> void:
	if not GameManager.submarine:
		return
	target_position = GameManager.submarine.position + Vector2(get_random_value_with_offset(100), get_random_value_with_offset(50))
	character_sprite.scale.x = int(target_position.x < position.x) * 2 - 1

func _on_health_health_depleted() -> void:
	state = State.DEAD
	glowy_bits.visible = false
	character_sprite.stop()

	rotation_degrees = 180.0

	await get_tree().create_timer(5.0).timeout
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
