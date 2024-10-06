extends Area2D
class_name FallingObject

# Variables to handle the speed and state
var falling_speed: float = 500.0  # Initial falling speed
var is_grabbed: bool = false
var fall_direction: Vector2 = Vector2(0, 1)  # Falling down
var grab_offset: Vector2 = Vector2.ZERO  # Offset between object position and mouse when grabbed
var velocity: Vector2 = Vector2.ZERO  # Current velocity of the object
var max_velocity: float = 600  # Maximum velocity limit
var score_value = 2

@export var falling_object_scene: PackedScene = preload("res://falling_objects/falling_object.tscn")
@export var texture_id: String = ""  # Exported variable for the texture ID

var sprite: Sprite2D # Sprite reference

# Preload the textures and assign IDs
var textures = {
	"bc1": preload("res://image/comments/bad/BadComment1.png"),
	"bc2": preload("res://image/comments/bad/BadComment2.png"),
	"bc1_grabbed": preload("res://image/comments/bad/BadComment1_grabbed.png"),
	"bc2_grabbed": preload("res://image/comments/bad/BadComment2_grabbed.png")
}

func _ready() -> void:
	add_to_group("falling_objects")
	
	# Randomly select one of the textures and its ID
	texture_id = "bc1" if randf() > 0.5 else "bc2"
	var texture = textures[texture_id]

	# Get the sprite node and set the initial texture
	sprite = get_node("Sprite2D")
	sprite.texture = texture
	
func _process(delta):
	set_falling_speed(GameProgress.speed_increase)
	
	if is_grabbed:
		var mouse_position = get_global_mouse_position()
		var new_position = mouse_position + grab_offset
		
		# Calculate the velocity
		velocity = (new_position - global_position) / delta
		# Move the object while maintaining the offset
		global_position = new_position  

	else:
		# Clamp velocity before applying
		if velocity.length() > max_velocity:
			velocity = velocity.normalized() * max_velocity
		
		# If not grabbed, apply the velocity from the release and blend it into falling down
		global_position += velocity * delta
		# Gradually switch to falling direction
		velocity = velocity.move_toward(fall_direction * falling_speed, falling_speed * delta)  

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
				sprite.texture = textures[texture_id + "_grabbed"] # Change texture to grabbed version
			elif not event.pressed and is_grabbed:
				is_grabbed = false
				sprite.texture = textures[texture_id] # Revert texture to the original version

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
			ScoreBoard.add_score(score_value)  # Update the global score when collision occurs
			queue_free()  # Remove the object after updating the score
