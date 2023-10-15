extends Node2D
class_name Game
static var Instance;

@export var batt1 = false;
@export var batt2 = false;
@export var batt3 = false;
@export var batt4 = false;
@export var batts = 0;
@onready var battLabel = $Camera2D/baseui/Label;

@export var socks = false;
@export var soda = false;

@export var paused = false;

@onready var pauseScreen = $Camera2D/Paused;
@onready var diedScreen = $Camera2D/Died;
@onready var winScreen = $Camera2D/Win;

var canPause = true;

func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") && canPause:
		paused = !paused;
		
	if !DisplayServer.window_is_focused() && canPause:
		paused = true;
		
	if paused:
		Engine.time_scale = 0;
		pauseScreen.visible = true;
	else:
		Engine.time_scale = 1;
		pauseScreen.visible = false;
		
	if winScreen.visible || diedScreen.visible:
		Engine.time_scale = 0;
		
	if (batt1 && batt2 && batt3 && batt4) || batts >= 4:
		winScreen.visible = true;
		canPause = false;
		
	battLabel.text = str(batts);


func _on_unpause_pressed():
	paused = false;

func dead():
	print("DIE")
	canPause = false;
	diedScreen.visible = true;
	pass


func _on_menu_pressed():
	Engine.time_scale = 1;
	#Loader.Instance.LoadMenu();
	get_tree().change_scene_to_packed(load("res://Menu with achors.tscn"));
	pass # Replace with function body.
