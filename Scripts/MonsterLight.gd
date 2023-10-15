extends OmniLight3D

@export var pixelsPerUnit = 77.2;
@onready var parent = $"../../..";
@export var screenWidth = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pixelOffset = parent.position.x - Monst.Instance.position.x;
	var unitOffset = pixelOffset / pixelsPerUnit;
	position.z = unitOffset + screenWidth / pixelsPerUnit + 0.5;
	pass
