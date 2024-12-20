extends Area2D
class_name FallingObject

# Static variable to track if any object is currently grabbed
static var any_object_grabbed: bool = false

# Variables to handle the speed and state
var falling_speed = GameProgress.falling_speed
var fall_direction: Vector2 = Vector2(0, 1)  # Falling down
var is_grabbed: bool = false
var was_grabbed: bool = false
var grab_offset: Vector2 = Vector2.ZERO  # Offset between object position and mouse when grabbed
var velocity: Vector2 = Vector2.ZERO  # Current velocity of the object
var max_velocity: float = 600
var score_value = 2

@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn")
@export var texture_id: String = ""  # Exported variable for the texture ID

var sprite: Sprite2D  # Sprite reference

func _ready() -> void:
	add_to_group("falling_objects")
	# Randomly select one of the textures and its ID
	var texture_keys = ["bc1", "bc2", "bc3", "bc4", "bc5"]
	texture_id = texture_keys[randi() % texture_keys.size()]
	var texture = ImageLoader.textures[texture_id]
	sprite = get_node("Sprite2D")
	sprite.texture = texture

func _process(delta: float) -> void:
	# Apply falling behavior when not grabbed
	if not is_grabbed:
		if velocity.length() > max_velocity: 	# Clamp velocity before applying
			velocity = velocity.normalized() * max_velocity
		# Apply the velocity and simulate falling
		global_position += velocity * delta
		velocity = velocity.move_toward(fall_direction * falling_speed, falling_speed * delta)

# Function to detect if the object is clicked
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_global_mouse_position()
		if is_point_in_body(mouse_position):
			if event.pressed and not is_grabbed and not any_object_grabbed:
				# Object is grabbed
				is_grabbed = true
				was_grabbed = true
				any_object_grabbed = true
				grab_offset = global_position - mouse_position
				if texture_id + "_grabbed" in ImageLoader.textures:
					sprite.texture = ImageLoader.textures[texture_id + "_grabbed"]
				#print("Object grabbed: ", texture_id)
			elif not event.pressed and is_grabbed:
				release_object()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_grabbed:
		# Handle object movement while grabbed
		var mouse_position = get_global_mouse_position()
		var new_position = mouse_position + grab_offset
		velocity = (new_position - global_position) / get_physics_process_delta_time()
		global_position = new_position

func release_object():
	is_grabbed = false
	any_object_grabbed = false
	if texture_id in ImageLoader.textures:
		sprite.texture = ImageLoader.textures[texture_id]

# Function to check if the mouse is within the collision shape
func is_point_in_body(point: Vector2) -> bool:
	var collision_shape = get_node("CollisionShape2D")
	if collision_shape.shape is RectangleShape2D:
		var rect = collision_shape.shape.get_rect()
		return rect.has_point(point - global_position)
	return false

# Called when another body enters this area and checks for object ID
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("falling_objects"):
		var other_object = area as FallingObject
		if other_object.texture_id == texture_id and (was_grabbed or other_object.was_grabbed):
			if !GameProgress.trigger_dialog_one:
				GameProgress.control_dialog_one()
			if is_grabbed:
				FallingObject.any_object_grabbed = false
			#print("Collision detected with another falling object of the same ID! ", texture_id)
			GameProgress.play_sound("res://assets/sounds/effects/pop.mp3")
			GameProgress.increase_emotional_level(1)
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	GameProgress.decrease_emotional_level(2)
	queue_free()
