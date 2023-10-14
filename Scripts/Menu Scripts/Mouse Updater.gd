extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scale = get_viewport_rect().size.y / 270;
	material.set_shader_parameter("mouse", get_viewport().get_mouse_position() / scale);
	pass
