extends Area2D
class_name FallingObject

# Variables to handle the speed and state
var falling_speed: float = 500.0  # Initial falling speed
var is_grabbed: bool = false
var fall_direction: Vector2 = Vector2(0, 1)  # Falling down
var grab_offset: Vector2 = Vector2.ZERO  # Offset between object position and mouse when grabbed
var score_value = 2

@export var texture_id: String = ""  # Exported variable for the texture ID

func _ready() -> void:
	add_to_group("falling_objects")
	
func _process(delta):
	set_falling_speed(GameProgress.speed_increase)
	if is_grabbed:
		# Move the object while maintaining the offset
		global_position = get_global_mouse_position() + grab_offset
	else:
		# Continue falling if not grabbed
		global_position += fall_direction * falling_speed * delta

# Function to modify speed dynamically
func set_falling_speed(new_speed: float):
	falling_speed = new_speed

# Function to detect if the object is clicked
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_position = get_global_mouse_position()
			if event.pressed and is_point_in_body(mouse_position):
				is_grabbed = true
				grab_offset = global_position - mouse_position  # Store the offset
			elif not event.pressed and is_grabbed:
				is_grabbed = false

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
		if other_object.texture_id == texture_id:
			print("Collision detected with another falling object of the same ID!")
			# Update the global score when collision occurs
			ScoreBoard.add_score(score_value)
			queue_free()  # Remove the object after updating the score
