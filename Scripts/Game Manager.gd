extends Node2D
class_name Game
static var Instance;

var batt1 = false;
var batt2 = false;
var batt3 = false;
var batt4 = false;

var socks = true;
var soda = false;

func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();


func _process(delta):
	if !DisplayServer.window_is_focused():
		Engine.time_scale = 0;
	else:
		Engine.time_scale = 1;
