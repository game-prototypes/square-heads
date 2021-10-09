extends KinematicBody2D

class_name Player

export var speed:float=100
export var life:int=100

onready var gun:=$Gun
onready var rocket_launcher:=$RocketLauncher
onready var life_bar:=$LifeBar

signal dead

func _ready():
	life_bar.initialize(life)

func _physics_process(delta):
	_look_update()
	if Input.is_action_just_pressed("shoot"):
		gun.shoot(_get_target_position())
	elif Input.is_action_just_pressed("secondary_shoot"):
		rocket_launcher.shoot(_get_target_position())
	_movement_update(delta)

func damage(damage:int):
	var new_life=life_bar.decrease_life(damage)
	if new_life<=0:
		emit_signal("dead")

func _movement_update(delta):
	var direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	var velocity = direction.normalized() * speed
	move_and_slide(velocity) 

func _look_update():
	var target=_get_target_position()
	look_at(target)

func _get_target_position():
	return get_global_mouse_position() 
