extends Reference
class_name FloodFill
# A floodfill algorithm to be implemented using MapData
var map_data
var hard_terrain_multiplier: float

func _init(_map_data, _hard_terrain_multiplier: float):
	map_data=_map_data
	hard_terrain_multiplier=_hard_terrain_multiplier


func execute(cell: Vector2, distance: float):
	var from=Vector2(max(cell.x-distance,0), max(cell.y-distance,0))
	var to=Vector2(cell.x+distance, cell.y+distance)
	
	var tiles=[]
	for i in range(from.x, to.x+1):
		for j in range(from.y,to.y+1):
			var new_cell=Vector2(i,j)
			if can_add_cell(new_cell, cell, distance):
				tiles.append(new_cell)
	return tiles


func can_add_cell(cell: Vector2, origin: Vector2, distance: float) -> bool:
	if cell==origin:
		return false
	var path=map_data.find_path(origin, cell)
	if !path or path.size() == 0:
		return false
	var cost=map_data.calculate_path_cost(path)
	return cost<=distance
