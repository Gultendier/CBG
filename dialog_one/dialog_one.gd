extends Control

func yes():
	get_tree().paused = false
	visible = false  # Hide the pause menu

func no():
	get_tree().paused = false
	visible = false  # Hide the pause menu

func pause():
	if not get_tree().paused:  # Check if already paused
		get_tree().paused = true
		visible = true  # Show the pause menu

func _on_yes_pressed() -> void:
	yes()

func _on_no_pressed() -> void:
	no()
