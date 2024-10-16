extends Node

# variables for falling speed
var falling_speed: float = 100

# variables for the game progress
var grabbed_for_the_first_time = false
var counter_dialog_one = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func increase_speed():
	falling_speed += 5
	
func trigger_dialog_one():
	counter_dialog_one += 1
	print("One: " , counter_dialog_one)
	if counter_dialog_one == 4:
		GameProgress.grabbed_for_the_first_time = true
		get_tree().paused = true
		print("paused")
		var main_scene = get_tree().current_scene
		if main_scene.has_method("show_dialog_one"):
			main_scene.show_dialog_one()
