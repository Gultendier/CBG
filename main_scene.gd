extends Node2D

@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn") # Preload the FallingObject scene
@onready var countdown_timer: Timer = $SpeedTimer

# Variables for spawning objects
var spawn_timer: float = 2.0  # Time in seconds between each spawn
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
	var random_x_position = randi() % int(screen_size.x) # Continuously update the label to display the current score
	
	falling_object.position = Vector2(random_x_position, 0) # Set the position (random X, Y starting at 0)

	add_child(falling_object) # Add the object as a child of the main scene


func update_score_label():
	$CanvasLayer/HBoxContainer/Label.text = "Score: " + str(ScoreBoard.score) # Update the Label's text to reflect the global score

# Timer for the speed increase of falling_objects
func _on_speed_timer_timeout() -> void:
	GameProgress.increase_speed()
	print("Timer")
