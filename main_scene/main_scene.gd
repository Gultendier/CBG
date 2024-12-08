extends Node2D

@onready var countdown_timer: Timer = $SpeedTimer
@onready var girl_image = $VBoxContainer/GirlImage
@onready var glitch_shader = $CanvasLayer/GlitchRect.material
@onready var color_overlay = $CanvasLayer/ColorOverlay

# Variables for spawning objects
var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn") 
var screen_size: Vector2 # Screen bounds to control objects spawn
@export var spawn_timer: float = 0.5  # Time in seconds between each spawn
@export var spawn_interval: float = 1.0  # Reset value for the timer
@export var spawn_y: float = -50
var object_positions = []

var girl_textures = {
	"happy": preload("res://image/girl/1. happy.png"),
	"neutral": preload("res://image/girl/2. neutral.png"),
	"upset": preload("res://image/girl/3. upset.png"),
	"depressed": preload("res://image/girl/4. depressed.png"),
	"crying": preload("res://image/girl/5. crying.png"),
	"dead": preload("res://image/gallow.png")
}

func _process(delta):
	# Decrease the spawn timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_object()
		spawn_timer = spawn_interval  # Reset the timer

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
	
func _on_emotion_check_timer_timeout():
	if (GameProgress.emotional_level > 80):
		progress_change(0.0, "happy", 0.0)
	elif (GameProgress.emotional_level <= 80 && GameProgress.emotional_level > 60):
		progress_change(0.0, "neutral", 0.0)
	elif (GameProgress.emotional_level <= 60 &&  GameProgress.emotional_level > 40):
		progress_change(0.0, "upset", 0.0)
	elif (GameProgress.emotional_level <= 40 &&  GameProgress.emotional_level > 20):
		progress_change(0.3, "depressed", 0.0)
	elif (GameProgress.emotional_level <= 20 &&  GameProgress.emotional_level > 0):
		progress_change(0.4, "crying", 0.1)
	elif (GameProgress.emotional_level <= 0):
		progress_change(0.5, "dead", 0.15)
		
func progress_change(alpha, image_name, shake_rate):
	var tween = create_tween()
	tween.tween_property(color_overlay,"color",Color(0,0,0,alpha),0.5)
	girl_image.texture = girl_textures[image_name]
	glitch_shader.set_shader_parameter("shake_rate", shake_rate)
	
func _input(event: InputEvent):
	if Input.is_action_pressed("ui_right"):
		_on_emotion_check_timer_timeout()
