extends CanvasLayer

class_name ui
signal game_started

@onready var end_of_game = $end_of_game

func _ready():
	pass

func on_game_over():
	end_of_game.visible = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
