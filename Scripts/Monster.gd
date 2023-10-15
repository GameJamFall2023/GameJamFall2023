extends Sprite2D
class_name Monst
static var Instance;

var frameRate = 8;
var animTimer = 0;

var frameRate2 = 12;
var animTimer2 = 0;

@export var fallAwayDelay = 15;
@export var fallAway = 0;
@export var catchup = false;

var fails = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animTimer += delta;
	var frameChange = floor(animTimer / (1.0 / frameRate));
	animTimer -= frameChange * (1.0 / frameRate);
	
	animTimer2 += delta;
	var frameChange2 = floor(animTimer2 / (1.0 / frameRate2));
	if frameChange2:
		material.set_shader_parameter("time24", Time.get_ticks_msec() / 6500.0);
	animTimer2 -= frameChange2 * (1.0 / frameRate2);
	
	frame = fmod((frame + frameChange), 5);
	
	if !catchup:
		fallAwayDelay -= delta;
	else:
		fallAway -= delta * 75;
		fallAway = max(fallAway, 0);
		
	if catchup && fallAway <= 0.0001:
		catchup = false;
		fallAwayDelay = 15 - fails * 2;
	
	if fallAwayDelay <= 0:
		fallAway += delta * ((10 - fails) / 10) * 10;
		fallAway = min(fallAway, 250);
	
	position.x = Player.Instance.position.x - 165 - fallAway;
	print(fallAway);
	print(fallAwayDelay)
	
func nyoom():
	catchup = true;
	
	if fallAway < 150:
		Game.Instance.dead();
