extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.y = get_viewport_rect().size.y / 270;
	scale.x = scale.y;
	position.x = get_viewport_rect().size.x / 2 - 240 * scale.x;;
	pass
