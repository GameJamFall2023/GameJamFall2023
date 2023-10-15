extends Control
class_name Loader
static var Instance

var intro = true;
var introTimer = 0;
var introLength = 10;
var fadeIn = 3;
var fadeStay = 4;

@onready var introContain = $"Intro";
@onready var godot = $"Intro/Label";
@onready var shader = $"Intro/BackBufferCopy/IntroPix";
@onready var shader2 = $"Intro/BackBufferCopy2/IntroPix2";

@onready var menuScene = preload("res://Menu with achors.tscn").instantiate();
@onready var gameScene = preload("res://Game Scene.tscn").instantiate();

@onready var menuCam = $MenuCamera;

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();
		
	#add_child(menuScene);
	#add_child(gameScene);
	#menuScene.visible = false;
	#menuScene.process_mode = Node.PROCESS_MODE_DISABLED;
	#gameScene.visible = false;
	#gameScene.process_mode = Node.PROCESS_MODE_DISABLED;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if intro:
		introTimer += delta;
		
		if introTimer < fadeIn:
			godot.self_modulate = Color(1.0, 1.0, 1.0, introTimer / fadeIn);
			var width = lerp(1, 480, introTimer / fadeIn);
			var height = lerp(1, 270, introTimer / fadeIn);
			shader.material.set_shader_parameter("screenSize", Vector2(width, height));
			shader2.material.set_shader_parameter("screenSize", Vector2(width, height));
			#shader2.material.set_shader_parameter("updateDistance", lerp(250, 0, introTimer / fadeIn));
		elif introTimer > fadeIn+fadeStay:
			var val = 1 - (introTimer-fadeIn-fadeStay) / fadeIn;
			godot.self_modulate = Color(1.0, 1.0, 1.0, val);
			var width = lerp(1, 480, val);
			var height = lerp(1, 270, val);
			shader.material.set_shader_parameter("screenSize", Vector2(width, height));
			shader2.material.set_shader_parameter("screenSize", Vector2(width, height));
			#shader2.material.set_shader_parameter("updateDistance", lerp(250, 0, val));
		else:
			godot.self_modulate = Color(1.0, 1.0, 1.0, 1.0);
			shader.material.set_shader_parameter("screenSize", Vector2(480, 270));
			shader2.material.set_shader_parameter("screenSize", Vector2(480, 270));
			#shader2.material.set_shader_parameter("updateDistance", 0);
			
		if introTimer >= fadeIn*2+fadeStay:
			intro = false;
			get_tree().change_scene_to_packed(load("res://Menu with achors.tscn"));
			introContain.visible = false;
			introContain.process_mode = Node.PROCESS_MODE_DISABLED;
			#menuScene.visible = true;
			#menuScene.process_mode = Node.PROCESS_MODE_ALWAYS;
	pass

func LoadGame():
	menuCam.enabled = false;
	CameraController.Instance.enabled = true;
	menuScene.visible = false;
	menuScene.process_mode = Node.PROCESS_MODE_PAUSABLE;
	gameScene.visible = true;
	gameScene.process_mode = Node.PROCESS_MODE_ALWAYS;

func LoadMenu():
	menuCam.enabled = true;
	CameraController.Instance.enabled = false;
	gameScene.pause
	menuScene.visible = true;
	menuScene.process_mode = Node.PROCESS_MODE_ALWAYS;
	gameScene.visible = false;
	gameScene.process_mode = Node.PROCESS_MODE_DISABLED;
