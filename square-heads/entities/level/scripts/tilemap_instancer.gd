extends Node

export var tilemap_path: NodePath
export var tile_name:String
export var scene:PackedScene

onready var tilemap:TileMap=get_node(tilemap_path)

# Called when the node enters the scene tree for the first time.
func instance_spawn_tiles(active:bool) -> void:
	var tile_id=tilemap.tile_set.find_tile_by_name(tile_name)
	if tile_id!=-1:
		var tiles=tilemap.get_used_cells_by_id(tile_id)
		for tile in tiles:
			var instance=_instance_in_tile(tile)
			instance.active=active


func _instance_in_tile(tile):
	var instance=scene.instance()
	instance.position=Utils.get_tile_center(tilemap, tile)
	add_child(instance)
	return instance
