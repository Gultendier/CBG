extends Node2D

# Preload the FallingObject scene
@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn")

# Preload the textures for random selection
var bad_comment_1: Texture2D = preload("res://image/comments/bad/BadComment1.png")
var bad_comment_2: Texture2D = preload("res://image/comments/bad/BadComment2.png")

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

	# Randomly select one of the two textures
	var random_texture = bad_comment_1 if randf() > 0.5 else bad_comment_2

	# Set the texture
	var sprite = falling_object.get_node("Sprite2D")  
	sprite.texture = random_texture
	
	# Random X position for the object to spawn within the screen width
	var random_x_position = randi() % int(screen_size.x)
	
	# Set the position (random X, Y starting at 0)
	falling_object.position = Vector2(random_x_position, 0)
	
	# Add the object as a child of the main scene
	add_child(falling_object)
