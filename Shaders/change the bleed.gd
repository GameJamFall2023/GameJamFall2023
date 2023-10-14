extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_parameter("bleedAmountX", sin(Time.get_ticks_msec() * 0.001) * 20)
	material.set_shader_parameter("bleedAmountY", cos(Time.get_ticks_msec() * 0.001) * 20)
	pass
