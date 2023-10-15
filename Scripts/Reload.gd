extends Control

var count = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	count -= delta;
	
	if count <= 0:
		get_tree().change_scene_to_packed(load("res://Game Scene.tscn"));
	pass
