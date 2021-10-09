extends Node2D

export var point_texture:Texture
export var draw_color:Color

func draw_line_2d(from:Vector2, to:Vector2, color=draw_color) -> Line2D:
	return draw_path([from, to], color)

func draw_point(pos:Vector2, color=draw_color) -> Sprite:
	var sprite=Sprite.new()
	sprite.texture=point_texture
	sprite.position=pos
	sprite.modulate=color
	sprite.z_index=10
	add_child(sprite)
	return sprite

func draw_path(path:Array, color=draw_color)->Line2D:
	var line=Line2D.new()
	line.width=2
	line.default_color=color
	line.z_index=10
	for point in path:
		line.add_point(point)
	add_child(line)
	return line


func get_tile_center(tilemap:TileMap, tile:Vector2)->Vector2:
	var half_cell_size:=tilemap.cell_size/2
	return tilemap.map_to_world(tile)+half_cell_size
