extends Node2D

export var speed=350
export var damage=25
export var blast_radius=1

export var explosion:PackedScene

func _physics_process(delta: float) -> void:
	var direction=Vector2.RIGHT.rotated(rotation)
	translate(direction*speed*delta)


func _on_collision(body: Node) -> void:
	var explosion_instance=explosion.instance()
	explosion_instance.position=to_global(Vector2.ZERO)
	explosion_instance.damage=damage
	explosion_instance.scale=Vector2(blast_radius, blast_radius)
	ProjectileSpawner.spawn_deferred(explosion_instance)
	queue_free()
