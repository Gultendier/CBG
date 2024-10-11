extends Node2D

@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn") # Preload the FallingObject scene
@onready var countdown_timer: Timer = $SpeedTimer

# Variables for spawning objects
var spawn_timer: float = 0.5  # Time in seconds between each spawn
var spawn_interval: float = 1.0  # Reset value for the timer
var spawn_y: float = -50
var screen_size: Vector2 # Screen bounds to control where the objects are spawned
var object_positions = []

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

func update_score_label():
	$CanvasLayer/HBoxContainer/ScoreBoard.text = "Score: " + str(ScoreBoard.score) # Update Label's 

# Timer for the speed increase of falling_objects
func _on_speed_timer_timeout() -> void:
	GameProgress.increase_speed()
	print("Timer")
