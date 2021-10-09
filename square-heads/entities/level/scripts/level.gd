extends Node2D
class_name Level
onready var tilemap=$TileMap
onready var enemy_spawns=$EnemySpawns

export var spawn:=true

var pathfinder:PathFinder

func _ready():
	pathfinder=PathFinder.new(tilemap)
	enemy_spawns.instance_spawn_tiles(spawn)

func find_path(from:Vector2, to:Vector2): # TODO: improve
	return pathfinder.find_path(from, to)
