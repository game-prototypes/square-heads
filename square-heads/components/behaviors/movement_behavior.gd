extends Node2D

var agent:Node2D

var direction_interest=[]
var ray_directions = []
var direction_lines=[]
var num_rays=6

enum MovementBehavior {
	navigate,
	simple
}

export(MovementBehavior) var behavior=MovementBehavior.navigate

# Based on https://kidscancode.org/godot_recipes/ai/context_map/
func _ready():
	direction_interest.resize(num_rays)
	ray_directions.resize(num_rays)
	direction_lines.resize(num_rays)
	
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
		if _display_navigation_lines():
			var line=_draw_debug_line(ray_directions[i])
			direction_lines[i]=line


func initialize(_agent:Node2D):
	agent=_agent

func _display_navigation_lines()->bool:
	return ProjectSettings.get("log/draw/navigation_lines")

func get_direction()->Vector2:
	_clear_interests()
	var target=get_tree().get_nodes_in_group("player")[0]
	var target_direction=_follow_target_simple(target)
	_add_interest_direction(target_direction,0.3)
	
	_set_danger()
#	var obstacles=_detect_obstacles()
#	for obstacle in obstacles:
#		var direction=agent.position.direction_to(obstacle.position)
#		var value=agent.position.distance_to(obstacle.position)
#		if value>0:
#			_add_danger_direction(direction, 100/value)
	
	
	if behavior==MovementBehavior.navigate:
		var navigation_direction=_calculate_target_navigation_direction(target)
		_add_interest_direction(navigation_direction)
	if _display_navigation_lines():
		for i in num_rays:
			_update_debug_line(direction_lines[i], ray_directions[i], direction_interest[i])
	
	var chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * max(direction_interest[i],0)
	chosen_dir = chosen_dir.normalized()
	
	return chosen_dir

func _get_targets()->Array:
	return get_tree().get_nodes_in_group("player")[0]

func _calculate_target_direction(target:Node2D):
	return (target.global_position-agent.global_position).normalized()

func _calculate_target_navigation_direction(target:Node2D):
	var path=Services.navigation.find_path(agent.global_position, target.global_position)
	var next_point=path[0]
	if path.size()>1:
		next_point=path[1]
	return (next_point-agent.global_position).normalized()

func _follow_target_simple(target:Node2D):
	var direction=(target.position-global_position).normalized()
	return direction

func _add_interest_direction(direction:Vector2, value=1):
	for i in num_rays:
		var d = ray_directions[i].rotated(global_rotation).dot(direction)
		direction_interest[i] += max(0, d)*value


func _draw_debug_line(direction:Vector2):
	var line=Line2D.new()
	line.width=2
	line.default_color=Color(0,1,0)
	line.z_index=10
	line.add_point(position)
	line.add_point(direction*30)
	add_child(line)
	return line


func _update_debug_line(line:Line2D, direction:Vector2, value:float):
	line.clear_points()
	line.add_point(position)
	line.add_point(direction*abs(value)*50)
	if value<0:
		line.default_color=Color(1,0,0)
	else:
		line.default_color=Color(0,1,0)


func _clear_interests():
	for i in direction_interest.size():
		direction_interest[i]=0
	
func _set_danger():
	var target=get_tree().get_nodes_in_group("player")[0]
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(global_position,
				global_position + ray_directions[i].rotated(global_rotation) * 100,
				[self, agent, target])

		if result:
			var distance=global_position.distance_to(result.position)
			direction_interest[i] -= 10/distance
