extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arena.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_mouse_entered() -> void:
	$sfx/buttonHover.play()

func _on_quit_mouse_entered() -> void:
	$sfx/buttonHover.play()
