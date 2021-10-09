extends Line2D

func set_path(origin:Vector2, target:Vector2):
	# Sets the current line path
	clear_points()
	add_point(origin)
	add_point(target)

func _on_animation_finished(_anim_name):
	queue_free() # Removes the node once the animation finishes (fade)
