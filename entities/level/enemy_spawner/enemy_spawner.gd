extends Node2D

export(Array, PackedScene) var enemies
export var spawn_time=5
export var active=true

func _ready():
	$Timer.wait_time=spawn_time

func spawn_enemy():
	var enemy_index = randi() % enemies.size()
	var instance=enemies[enemy_index].instance()
	instance.position=position
	EnemySpawner.spawn(instance)


func _on_spawn_time() -> void:
	if active:
		spawn_enemy()
