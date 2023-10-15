extends Control

@onready var settingsPanel = $"../Settings";
@onready var creditsPanel = $"../Credits";
@onready var buttonSound = $"../../Button";
@onready var mouseShader = $"../Mouse Shader";

var fadeTimer = 0;
var fadeLength = 1.5;
var fading = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fading:
		fadeTimer += delta;
		mouseShader.material.set_shader_parameter("updateDistance", 100 * (1 + fadeTimer * 50));
		mouseShader.material.set_shader_parameter("time", 1.5);
		
		if fadeTimer > fadeLength:
			#Loader.Instance.LoadGame();
			get_tree().change_scene_to_packed(load("res://Game Scene.tscn"));
	pass


func _on_quit_pressed():
	buttonSound.play();
	get_tree().quit();
	pass # Replace with function body.

func _on_settings_pressed():
	buttonSound.play();
	settingsPanel.visible = true;
	pass # Replace with function body.

func _on_close_settings_pressed():
	buttonSound.play();
	settingsPanel.visible = false;
	pass # Replace with function body.

func _on_play_pressed():
	buttonSound.play();
	fading = true;
	pass # Replace with function body.

func _on_credits_pressed():
	buttonSound.play();
	creditsPanel.visible = true;
	pass # Replace with function body.

func _on_close_credits_pressed():
	buttonSound.play();
	creditsPanel.visible = false;
	pass # Replace with function body.

func _on_window_mode_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
