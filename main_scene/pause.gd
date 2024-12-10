extends Control

func _on_continue_pressed() -> void:
	get_tree().paused = false
	$CanvasLayer.visible = false


func _on_exit_pressed() -> void:
	get_tree().paused = false
	GameProgress.emotional_level = 70
	GameProgress.falling_speed = 100
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
