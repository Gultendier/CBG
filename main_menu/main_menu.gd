extends Control

func _on_start_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://main_scene/main_scene.tscn")



func _on_exit_pressed() -> void:
	get_tree().quit()
