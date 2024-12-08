extends Node

@export var emotional_level = 70

# Variables for falling speed
@export var falling_speed: float = 100

# Variables for the game progress
var trigger_dialog_one = false
var counter_dialog_one = 0

# Preloaded Dialogic style and timeline
var dialog_one_style: DialogicStyle
var dialog_one_timeline

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Load and prepare the Dialogic style
	dialog_one_style = load("res://dialog_one_style/dialog_one_style.tres")
	dialog_one_style.prepare()
	# Preload the Dialogic timeline
	dialog_one_timeline = Dialogic.preload_timeline("res://dialog_one_style/dialog_one_timeline.dtl")
	
func increase_speed():
	falling_speed += 5

func increase_emotional_level(increase):
	emotional_level += increase

func decrease_emotional_level(decrease):
	emotional_level -= decrease

# Functions to control dialog one
func control_dialog_one():
	counter_dialog_one += 1
	print("One: ", counter_dialog_one)
	if counter_dialog_one == 4:
		# Start the dialog timeline
		Dialogic.timeline_ended.connect(end_dialog_one)
		Dialogic.start(dialog_one_timeline).process_mode = Node.PROCESS_MODE_ALWAYS
		Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		trigger_dialog_one = true
		print("paused")
		
func end_dialog_one():
	Dialogic.timeline_ended.disconnect(end_dialog_one)
	get_tree().paused = false

func dialog_one_choice_yes():
	emotional_level += 10
	print(emotional_level)
	
func dialog_one_choice_no():
	emotional_level -= 10
	print(emotional_level)
