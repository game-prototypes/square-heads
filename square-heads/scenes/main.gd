extends Node2D

onready var player=$Player

func _ready():
	Log.info("Square Heads v0.1")
	var level=$Level
	Services.navigation=NavigationService.new(level)
	randomize()


func _on_player_dead() -> void:
	Log.info("Dead")
