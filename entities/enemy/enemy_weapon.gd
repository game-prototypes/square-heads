extends Node2D

var _current_attack_delay:float=0
export var attack_delay:float=2
export var damage:int=10

func _process(delta:float):
	_current_attack_delay=max(_current_attack_delay-delta, 0)

func attack(target:Player):
	if _current_attack_delay<=0:
		target.damage(damage)
		_current_attack_delay=attack_delay
