extends CharacterBody2D
# Loosely based on https://kidscancode.org/godot_recipes/3.x/2d/car_steering/
class_name PlayerCar


@export var player: int = 0
@export var steering_angle: int = 25
@export var acceleration: float = 4000
@export var max_speed: float = 400

var steering: float = 0
var speed: float = 0

func _ready() -> void:
    #GameManager.player = self
    pass



func _physics_process(delta: float) -> void:

    var steering_input: float 
    var acceleration_input: float
    if Input.is_joy_known(0):
        steering_input = Input.get_joy_axis(player,JOY_AXIS_LEFT_X)
        acceleration_input = -Input.get_joy_axis(player,JOY_AXIS_LEFT_Y)
    else:
        steering_input = Input.get_axis("player1_left","player1_right")
        acceleration_input = Input.get_axis("player1_down","player1_up")

    var steering = steering_input * deg_to_rad(steering_angle) * delta
    rotate(steering)
    velocity = transform.x * (acceleration_input * acceleration * delta)
    move_and_slide()

func attacked(damage:int):
    print("Damage taken: ", damage)


func _on_health_health_depleted() -> void:
    print("you died!")
