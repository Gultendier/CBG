extends Node2D

@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn") # Preload the FallingObject scene
@onready var countdown_timer: Timer = $SpeedTimer
@onready var happy = preload("res://image/girl/girlPlaceholder.png")
@onready var girl_image = $HBoxContainer/GirlImage

# Variables for spawning objects
var screen_size: Vector2 # Screen bounds to control objects spawn
var spawn_timer: float = 0.5  # Time in seconds between each spawn
var spawn_interval: float = 1.0  # Reset value for the timer
var spawn_y: float = -50
var object_positions = []
# Variables for Emotional
var emotional_level_1 = false
var emotional_level_2 = false
var emotional_level_3 = false
var emotional_level_4 = false
var emotional_level_5 = false
var emotional_level_6 = false


func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	# Decrease the spawn timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_object()
		spawn_timer = spawn_interval  # Reset the timer
	update_score_label()

# Function to spawn a falling object
func spawn_object():
	print("spawned")
	var spawn_position = get_valid_spawn_position()
	if spawn_position != null:
		# Instantiate the falling object scene
		var falling_object = falling_object_scene.instantiate()
		falling_object.position = spawn_position	
		# Add the object as a child of the main scene
		add_child(falling_object)
		object_positions.append(spawn_position)

func get_valid_spawn_position() -> Vector2:
	var viewport = get_viewport_rect()
	var spawn_x = randf_range(0, viewport.size.x)
	var spawn_position = Vector2(spawn_x, spawn_y)

	return spawn_position

# Timer for the speed increase of falling_objects
func _on_speed_timer_timeout() -> void:
	GameProgress.increase_speed()
	print("Timer")
	
func update_score_label():
	$CanvasLayer/HBoxContainer/ScoreBoard.text = "Score: " + str(ScoreBoard.score)

func _on_emotion_check_timer_timeout() -> void:
	change_girl_image_through_emotional_level()

func change_girl_image_through_emotional_level():
	
	if (GameProgress.emotional_level > 80):
		print("Waited")
	elif (GameProgress.emotional_level <= 80 && GameProgress.emotional_level > 60):
		print("Waited 2")
	elif (GameProgress.emotional_level <= 60 &&  GameProgress.emotional_level > 40):
		print("Waited 3")
	elif (GameProgress.emotional_level <= 40 &&  GameProgress.emotional_level > 20):
		print("Waited 4")
	elif (GameProgress.emotional_level <= 20 &&  GameProgress.emotional_level > 0):
		print("Waited 5")
	elif (GameProgress.emotional_level <= 0):
		print("Waited 6")
