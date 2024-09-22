extends Node2D

# Preload the FallingObject scene
@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn")

# Variables for spawning objects
var spawn_timer: float = 2.0  # Time in seconds between each spawn
var spawn_interval: float = 2.0  # Reset value for the timer

# Screen bounds to control where the objects are spawned
var screen_size: Vector2

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

# Function to spawn a falling object
func spawn_object():
	# Instantiate the falling object scene
	var falling_object = falling_object_scene.instantiate()
	
	# Random X position for the object to spawn within the screen width
	var random_x_position = randi() % int(screen_size.x)
	
	# Set the position (random X, Y starting at 0)
	falling_object.position = Vector2(random_x_position, 0)
	
	# Add the object as a child of the main scene
	add_child(falling_object)
