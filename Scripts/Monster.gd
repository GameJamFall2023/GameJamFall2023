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
var doomed = false;
var playingDie = false;

@onready var distortion = $"../BackBufferCopy/Moster Distortion";
@onready var staticOut = $"../BackBufferCopy2/Static";
@onready var distortionCon = $"../BackBufferCopy";
@onready var staticOutCon = $"../BackBufferCopy2";
@onready var dieLmao = $"Die lmao";

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
		dieLmao.material.set_shader_parameter("time24", Time.get_ticks_msec() / 6500.0);
		material.set_shader_parameter("time24", Time.get_ticks_msec() / 6500.0);
	animTimer2 -= frameChange2 * (1.0 / frameRate2);
	
	frame = fmod((frame + frameChange), 5);
	
	if playingDie:
		dieLmao.frame = clamp(dieLmao.frame + frameChange, 0, 15);
		print(dieLmao.frame)
	
	if !catchup:
		fallAwayDelay -= delta;
	else:
		fallAway -= delta * 75;
		fallAway = max(fallAway, 0);
		
	if catchup && fallAway <= 0.0001:
		catchup = false;
		fallAwayDelay = 15 - fails * 2;
		
		if doomed:
			region_enabled = true;
			dieLmao.visible = true;
			playingDie = true;
	
	if fallAwayDelay <= 0:
		fallAway += delta * ((10 - fails) / 10) * 10;
		fallAway = min(fallAway, 250);
	
	position.x = Player.Instance.position.x - 141 - fallAway;
	distortionCon.position.x = CameraController.Instance.position.x;
	staticOutCon.position.x = CameraController.Instance.position.x;
	
	distortion.material.set_shader_parameter("mons", Vector2(75-fallAway, 166));
	if playingDie:
		distortion.material.set_shader_parameter("updateDistance", 200 + 500 * dieLmao.frame / 15);
		
		if dieLmao.frame == 4:
			Player.Instance.visible = false;
			Player.Instance.process_mode = Node.PROCESS_MODE_DISABLED;
			
		if dieLmao.frame > 8:
			staticOut.material.set_shader_parameter("static", (dieLmao.frame - 8) / 6.0);
			
		if dieLmao.frame == 15:
			get_tree().change_scene_to_packed(load("res://Reload.tscn"));
	
func nyoom():
	catchup = true;
	
	if fallAway < 75:
		doomed = true;
		#Game.Instance.dead();
