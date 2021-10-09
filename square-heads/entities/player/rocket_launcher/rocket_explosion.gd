extends Area2D

var damage:int

var ticks=0

func _physics_process(delta):
	ticks+=1
	if ticks==4:
		var collisions=get_overlapping_areas()
		collisions.append_array(get_overlapping_bodies())
		
		for collision in collisions:
			if collision.is_in_group("enemy"):
				collision.on_damage(damage)

func _on_animation_finished(anim_name: String) -> void:
	queue_free()
