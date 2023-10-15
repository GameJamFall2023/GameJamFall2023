extends Node2D
class_name Game
static var Instance;

@export var batt1 = false;
@export var batt2 = false;
@export var batt3 = false;
@export var batt4 = false;

@export var socks = false;
@export var soda = false;

@export var paused = false;

@onready var pauseScreen = $Camera2D/Paused;

func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		paused = !paused;
		
	if !DisplayServer.window_is_focused():
		paused = true;
		
	if paused:
		Engine.time_scale = 0;
		pauseScreen.visible = true;
	else:
		Engine.time_scale = 1;
		pauseScreen.visible = false;


func _on_unpause_pressed():
	paused = false;

func dead():
	print("DIE")
	pass
