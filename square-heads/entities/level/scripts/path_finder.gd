extends Reference
class_name PathFinder

var astar = AStar2D.new()

var tilemap: TileMap
var map_bounds:Rect2

var draw_matrix:bool

func _init(_tilemap:TileMap):
	draw_matrix=ProjectSettings.get_setting("log/draw/pathfinding")
	tilemap=_tilemap
	map_bounds=tilemap.get_used_rect()
	
	var walkable_cells_list = _astar_add_walkable_cells()
	if draw_matrix:
		for cell in walkable_cells_list:
			Utils.draw_point(cell)
	_astar_connect_walkable_cells(walkable_cells_list)

func find_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var from_id=astar.get_closest_point(from)
	var to_id=astar.get_closest_point(to)

	return _find_path_id(from_id, to_id)

func _find_path_id(from_id: int, to_id: int)->PoolVector2Array:
	if !astar.has_point(from_id) or !astar.has_point(to_id):
		return PoolVector2Array()
	return astar.get_point_path(from_id,to_id)

func _astar_add_walkable_cells() -> Array:
	var points_array = []
	for y in range(map_bounds.position.y, map_bounds.end.y):
		for x in range(map_bounds.position.x, map_bounds.end.x):
			var tile=Vector2(x,y)
			if _is_walkable_tile(tile):
				var point = _astar_add_tile(tile)
				points_array.append(point)
	return points_array

func _astar_connect_walkable_cells(points_array: Array):
	var cell_size:=tilemap.cell_size
	for point in points_array:
		var point_id = _calculate_point_id(point)
		for local_y in range(-cell_size.y, cell_size.y*2, cell_size.y):
			for local_x in range(-cell_size.x, cell_size.x*2, cell_size.x):
				var point_relative = Vector2(point.x + local_x, point.y + local_y)
				if _can_connect_points(point, point_relative):
					var point_relative_id=_calculate_point_id(point_relative)
					astar.connect_points(point_id, point_relative_id)
					if draw_matrix:
						Utils.draw_line_2d(point, point_relative)

func _is_walkable_tile(tile:Vector2)->bool:
	var cell=tilemap.get_cell(int(tile.x),int(tile.y))
	if cell==tilemap.INVALID_CELL:
		return false
	var is_obstacle=tilemap.get_collision_layer_bit(cell)
	return not is_obstacle
	
func _astar_add_tile(tile:Vector2)->Vector2:
	var point=Utils.get_tile_center(tilemap, tile)
	point=tilemap.to_global(point)
	var point_index = _calculate_point_id(point)
	astar.add_point(point_index, point)
	return point

func _can_connect_points(cell1: Vector2, cell2: Vector2) -> bool:
	var cell1_id = _calculate_point_id(cell1)
	var cell2_id = _calculate_point_id(cell2)
	if cell1 == cell2 or not astar.has_point(cell1_id) or not astar.has_point(cell2_id):
		return false
	if astar.are_points_connected(cell1_id, cell2_id):
		return false
	
	# Check diagonal
	var d1=tilemap.world_to_map(Vector2(cell1.x, cell2.y))
	var d2=tilemap.world_to_map(Vector2(cell2.x, cell1.y))
	
	var is_d1_obstacle=tilemap.get_collision_layer_bit(tilemap.get_cell(d1.x,d1.y))
	var is_d2_obstacle=tilemap.get_collision_layer_bit(tilemap.get_cell(d2.x,d2.y))
	
	if is_d1_obstacle or is_d2_obstacle:
		return false
	return true

func _calculate_point_id(point: Vector2) -> int:
	var map_size:=map_bounds.size
	var cell_size:=tilemap.cell_size
	return int(point.x + (map_size.x*cell_size.x) * point.y)
