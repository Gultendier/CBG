extends Node2D

@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn") # Preload the FallingObject scene
@onready var countdown_timer: Timer = $SpeedTimer

# Variables for spawning objects
var spawn_timer: float = 1.0  # Time in seconds between each spawn
var spawn_interval: float = 2.0  # Reset value for the timer
var screen_size: Vector2 # Screen bounds to control where the objects are spawned

func _ready():
	# Get the screen size
	screen_size = get_viewport_rect().size
	# Start spawning objects
	spawn_object()

func _process(delta):
	# Decrease the spawn timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_object()
		spawn_timer = spawn_interval  # Reset the timer
		
	update_score_label() # Continuously update the label to display the current score

# Function to spawn a falling object
func spawn_object():
	# Instantiate the falling object scene
	var falling_object = falling_object_scene.instantiate()
	# Get the viewport rectangle
	var viewport = get_viewport_rect()
	# Calculate the center point
	var center_x = viewport.size.x * 0.5
	# Determine the distance from the center (1/4 of the screen width)
	var distance_from_center = viewport.size.x * 0.25
	 # Generate random offsets
	var random_offset_x = randf_range(-distance_from_center, distance_from_center)
	# Calculate the final spawn position
	var spawn_position = Vector2(center_x + random_offset_x, -70)
	# Set the position of the falling object
	falling_object.position = spawn_position
	# Start falling animation
	
	# Add the object as a child of the main scene
	add_child(falling_object)



func update_score_label():
	$CanvasLayer/HBoxContainer/ScoreBoard.text = "Score: " + str(ScoreBoard.score) # Update the Label's text to reflect the global score

# Timer for the speed increase of falling_objects
func _on_speed_timer_timeout() -> void:
	GameProgress.increase_speed()
	print("Timer")