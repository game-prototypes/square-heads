extends KinematicBody2D

class_name Enemy

export var life:int = 100
export var speed:float = 100
export var attack_range:float=10

onready var life_bar:=$LifeBar
onready var movement_behaviour:=$MovementBehaviour
onready var weapon:=$EnemyWeapon
onready var attack_area:=$AttackArea

enum BehaviorState{
	idle,
	attacking
	moving_to_taget
}


var target:Node2D

var _next_point
var state:int=BehaviorState.idle

func _ready():
	print("Enemy Ready")
	life_bar.initialize(life)
	movement_behaviour.initialize(self)
	target=get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float):
	match state:
		BehaviorState.idle:
			if target:
				state=BehaviorState.moving_to_taget
		BehaviorState.moving_to_taget:
			var direction=movement_behaviour.get_direction()
			var velocity=direction*speed
			move_and_slide(velocity)
			if _can_attack():
				state=BehaviorState.attacking
		BehaviorState.attacking:
			if	_can_attack():
				_attack(target)
			else:
				state=BehaviorState.moving_to_taget

func on_damage(received_damage:int):
	var new_life=life_bar.decrease_life(received_damage)
	if new_life<=0:
		queue_free()

func _attack(attack_target:Player):
	weapon.attack(attack_target)

func _can_attack()->bool:
	return attack_area.overlaps_body(target)
