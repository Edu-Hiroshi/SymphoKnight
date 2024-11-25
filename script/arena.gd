extends Node2D

var gambiarra = true

func _process(_delta):
	if gambiarra:
		$player/victoryText.visible = false
	victory_check()

func victory_check():
	if global.boss_dead and gambiarra:
		gambiarra = false
		$victoryTimer.start()
		$sfx/victoryMusic.play()
		$player/victoryText.visible = true

func _on_victory_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/endscreen.tscn")
