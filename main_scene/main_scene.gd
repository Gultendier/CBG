extends Node2D

@onready var countdown_timer: Timer = $SpeedTimer
@onready var girl_image = $VBoxContainer/GirlImage
@onready var glitch_shader = $CanvasLayer/GlitchRect.material
@onready var color_overlay = $CanvasLayer/ColorOverlay
@onready var main_music = $MainMusic

# Variables for spawning objects
var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn") 
var screen_size: Vector2 # Screen bounds to control objects spawn
@export var spawn_timer: float = 0.5  ## Time in seconds between each spawn
@export var spawn_interval: float = 1.0  ## Reset value for the timer
@export var spawn_y: float = -50 ## Spawn coordinates Y
var object_positions = []

func _process(delta):
	# Decrease the spawn timer
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_object()
		spawn_timer = spawn_interval  # Reset the timer

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

# Timer for the speed increase of falling_objects
func _on_speed_timer_timeout() -> void:
	GameProgress.increase_speed(5)
	if GameProgress.falling_speed >= 300:
		countdown_timer.wait_time = 8
		spawn_timer = 0.1
		spawn_interval = 0.6
	elif GameProgress.falling_speed >= 250:
		countdown_timer.wait_time = 7
		spawn_timer = 0.2
		spawn_interval = 0.7
	elif GameProgress.falling_speed >= 200:
		countdown_timer.wait_time = 6
		spawn_timer = 0.3
		spawn_interval = 0.8
	elif GameProgress.falling_speed >= 150:
		countdown_timer.wait_time = 5
		spawn_timer = 0.4
		spawn_interval = 0.9

func _on_emotion_check_timer_timeout():
	if (GameProgress.emotional_level > 80):
		progress_change(0.0, "happy", 0.0, 1)
	elif (GameProgress.emotional_level <= 80 && GameProgress.emotional_level > 60):
		progress_change(0.0, "neutral", 0.0, 1)
	elif (GameProgress.emotional_level <= 60 &&  GameProgress.emotional_level > 40):
		progress_change(0.1, "upset", 0.0, 0.8)
	elif (GameProgress.emotional_level <= 40 &&  GameProgress.emotional_level > 20):
		progress_change(0.25, "depressed", 0.0, 0.5)
	elif (GameProgress.emotional_level <= 20 &&  GameProgress.emotional_level > 0):
		progress_change(0.4, "crying", 0.15, 0.2)
	elif (GameProgress.emotional_level <= 0):
		progress_change(0.5, "crying", 0.2, 0.2)
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://death_scene/death_scene.tscn")
		
func progress_change(alpha, image_name, shake_rate, pitch):
	var tween = create_tween()
	tween.tween_property(color_overlay,"color",Color(0,0,0,alpha),0.5)
	girl_image.texture = ImageLoader.girl_textures[image_name]
	glitch_shader.set_shader_parameter("shake_rate", shake_rate)
	main_music.pitch_scale = pitch
	
func _input(event: InputEvent):
	if Input.is_action_pressed("ui_cancel"):
		if (!get_tree().paused):
			$Pause/CanvasLayer.visible = true
			get_tree().paused = true
	if Input.is_action_pressed("ui_up"):	
		GameProgress.increase_emotional_level(20)
		_on_emotion_check_timer_timeout()
	if Input.is_action_pressed("ui_down"):
		GameProgress.decrease_emotional_level(20)
		_on_emotion_check_timer_timeout()
	
