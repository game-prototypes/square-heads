extends Reference

class_name NavigationService

var _level:Level

func _init(level:Level):
	_level=level
	

func find_path(from:Vector2, to:Vector2)->PoolVector2Array:
	if not _level:
		return PoolVector2Array()
	else:
		return _level.find_path(from, to)
