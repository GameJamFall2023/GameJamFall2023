extends Control

@export var bleedX = 0;
@export var bleedY = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_parameter("bleedAmountX", bleedX)
	material.set_shader_parameter("bleedAmountY", bleedY)
	pass
