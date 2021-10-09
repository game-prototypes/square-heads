extends Node

func spawn(instance:Node):
	add_child(instance)

func spawn_deferred(instance:Node):
	call_deferred("spawn", instance)
