extends Node2D

@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn") # Preload the FallingObject scene
@onready var countdown_timer: Timer = $SpeedTimer

# Variables for spawning objects
var spawn_timer: float = 0.5  # Time in seconds between each spawn
var spawn_interval: float = 1.0  # Reset value for the timer
var spawn_y: float = -50
var screen_size: Vector2 # Screen bounds to control where the objects are spawned

# List to store positions of all spawned objects
var object_positions = []
var min_spawn_distance = 100  # Minimum distance between spawns

func _ready():
	screen_size = get_viewport_rect().size 	# Get the screen size

func _process(delta):
	# Decrease the spawn timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_object()
		spawn_timer = spawn_interval  # Reset the timer
		
	update_score_label() # Continuously update the label to display the current score

# Function to spawn a falling object
func spawn_object():
	var spawn_position = get_valid_spawn_position()
	if spawn_position != null:
		# Instantiate the falling object scene
		var falling_object = falling_object_scene.instantiate()
		falling_object.position = spawn_position	
		# Add the object as a child of the main scene
		add_child(falling_object)
		# Store the spawn position to prevent future spawns too close to this one
		object_positions.append(spawn_position)

# Function to get a valid spawn position that isn't too close to existing objects
func get_valid_spawn_position() -> Vector2:
	var viewport = get_viewport_rect()
	var spawn_x = randf_range(0, viewport.size.x)
	var spawn_position = Vector2(spawn_x, spawn_y)

	# Check distance to existing objects
	for existing_pos in object_positions:
		if existing_pos.distance_to(spawn_position) < min_spawn_distance:
			print("Too close to existing object, finding new position")
			pass
	# If valid, return the spawn position
	return spawn_position

func update_score_label():
	$CanvasLayer/HBoxContainer/ScoreBoard.text = "Score: " + str(ScoreBoard.score) # Update the Label's text to reflect the global score

# Timer for the speed increase of falling_objects
func _on_speed_timer_timeout() -> void:
	GameProgress.increase_speed()
	print("Timer")
