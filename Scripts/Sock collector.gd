extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body == Player.Instance:
		Game.Instance.socks = true;
		Player.Instance.Running.texture = load("res://Sprites/run_loop_socks_done.png");
		Player.Instance.Jumping.texture = load("res://Sprites/jump_loop_socks_done.png");
		Player.Instance.Sliding.texture = load("res://Sprites/slide_loop_socks_done.png");
		get_parent().queue_free();
	pass # Replace with function body.
