extends Control

@onready var settingsPanel = $"../Settings";
@onready var creditsPanel = $"../Credits";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit();
	pass # Replace with function body.

func _on_settings_pressed():
	settingsPanel.visible = true;
	pass # Replace with function body.

func _on_close_settings_pressed():
	settingsPanel.visible = false;
	pass # Replace with function body.

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Test Runner.tscn");
	pass # Replace with function body.

func _on_credits_pressed():
	creditsPanel.visible = true;
	pass # Replace with function body.

func _on_close_credits_pressed():
	creditsPanel.visible = false;
	pass # Replace with function body.
