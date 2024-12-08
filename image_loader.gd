extends Node

var textures = {}
var girl_textures = {}

func _ready():
	# Load bad comment textures
	textures["bc1"] = load_resource("res://image/comments/bad/BadComment1.png")
	textures["bc1_grabbed"] = load_resource("res://image/comments/bad/BadComment1_grabbed.png")
	textures["bc2"] = load_resource("res://image/comments/bad/BadComment2.png")
	textures["bc2_grabbed"] = load_resource("res://image/comments/bad/BadComment2_grabbed.png")
	textures["bc3"] = load_resource("res://image/comments/bad/BadComment3.png")
	textures["bc3_grabbed"] = load_resource("res://image/comments/bad/BadComment3_grabbed.png")
	textures["bc4"] = load_resource("res://image/comments/bad/BadComment4.png")
	textures["bc4_grabbed"] = load_resource("res://image/comments/bad/BadComment4_grabbed.png")
	textures["bc5"] = load_resource("res://image/comments/bad/BadComment5.png")
	textures["bc5_grabbed"] = load_resource("res://image/comments/bad/BadComment5_grabbed.png")

	# Load girl textures
	girl_textures["happy"] = load_resource("res://image/girl/1. happy.png")
	girl_textures["neutral"] = load_resource("res://image/girl/2. neutral.png")
	girl_textures["upset"] = load_resource("res://image/girl/3. upset.png")
	girl_textures["depressed"] = load_resource("res://image/girl/4. depressed.png")
	girl_textures["crying"] = load_resource("res://image/girl/5. crying.png")
	girl_textures["dead"] = load_resource("res://image/gallow.png")

func load_resource(path: String) -> Resource:
	var resource = ResourceLoader.load(path)
	if not resource:
		print("Failed to load resource: %s" % path)
	return resource
