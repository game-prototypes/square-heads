extends Node2D

export var rocket:PackedScene

func shoot(target:Vector2):
	var rocket_instance=rocket.instance()
	rocket_instance.position=to_global(Vector2.ZERO)
	ProjectileSpawner.spawn(rocket_instance)
	rocket_instance.look_at(target)	
