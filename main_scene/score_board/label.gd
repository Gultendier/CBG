extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var black = Color(0,0,0)
	set("theme_override_colors/font_color",black)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
