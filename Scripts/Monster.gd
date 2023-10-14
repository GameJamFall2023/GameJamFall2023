extends Sprite2D

var frameRate = 12;
var animTimer = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animTimer += delta;
	var frameChange = floor(animTimer / (1.0 / frameRate));
	animTimer -= frameChange * (1.0 / frameRate);
	
	frame = fmod((frame + frameChange), 5);
	
	position.x = Player.Instance.position.x;
