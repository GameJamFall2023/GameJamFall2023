extends Camera2D
class_name CameraController

static var Instance;

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	zoom.y = get_viewport_rect().size.y / 270;
	zoom.x = zoom.y;
	pass
