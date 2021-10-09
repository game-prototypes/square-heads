extends Node2D

onready var raycast=$RayCast
onready var gun_audio=$GunAudio #BANG!

export var damage:int=10

export (PackedScene) var bullet_trail

func shoot(target:Vector2):
	gun_audio.play() # BANG!

	raycast.cast_to=to_local(target) 
	raycast.force_raycast_update()
	
	var collision_point=target
	if raycast.is_colliding():
		collision_point=raycast.get_collision_point()
		var collision_node=raycast.get_collider()
		
		if collision_node.is_in_group("enemy"):
			collision_node.on_damage(damage)
	
	var bullet_instance=bullet_trail.instance()
	bullet_instance.set_path(to_global(Vector2.ZERO), collision_point)
	ProjectileSpawner.spawn(bullet_instance)
