extends Node2D

# Preload the FallingObject scene
@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn")

# Preload the textures and assign IDs
var textures = {
	"bc1": preload("res://image/comments/bad/BadComment1.png"),
	"bc2": preload("res://image/comments/bad/BadComment2.png")
}

# Variables for spawning objects
var spawn_timer: float = 2.0  # Time in seconds between each spawn
var spawn_interval: float = 2.0  # Reset value for the timer

# Screen bounds to control where the objects are spawned
var screen_size: Vector2

func _ready():
	# Get the screen size
	screen_size = get_viewport_rect().size
	print_tree()
	
	# Start spawning objects
	spawn_object()

func _process(delta):
	# Decrease the spawn timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_object()
		spawn_timer = spawn_interval  # Reset the timer
		
# Continuously update the label to display the current score
	update_score_label()

# Function to spawn a falling object
func spawn_object():
	# Instantiate the falling object scene
	var falling_object = falling_object_scene.instantiate()

	# Randomly select one of the textures and its ID
	var texture_id = "bc1" if randf() > 0.5 else "bc2"

	var texture = textures[texture_id]

	# Set the texture
	var sprite = falling_object.get_node("Sprite2D")
	sprite.texture = texture
	
	# Store the texture ID in the falling object (using a custom property)
	falling_object.set("texture_id", texture_id)

	# Random X position for the object to spawn within the screen width
	var random_x_position = randi() % int(screen_size.x)
	
	# Set the position (random X, Y starting at 0)
	falling_object.position = Vector2(random_x_position, 0)
	
	# Add the object as a child of the main scene
	add_child(falling_object)

func update_score_label():
# Update the Label's text to reflect the global score
	$CanvasLayer/HBoxContainer/Label.text = "Score: " + str(ScoreBoard.score)

# Function to check the texture ID
func check_texture_id(falling_object, id_to_check: String) -> bool:
	return falling_object.get("texture_id") == id_to_check
