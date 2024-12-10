extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameProgress.falling_speed = 100
	GameProgress.emotional_level = 70
	await get_tree().create_timer(5.0).timeout
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
