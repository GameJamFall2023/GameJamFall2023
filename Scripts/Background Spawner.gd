extends Node2D

@onready var testBG = load("res://Backgrounds/Test/testVidBG.tscn");
var backgrounds = {};
var backgroundWidth = 480;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playerPos = Player.Instance.position.x - fmod(Player.Instance.position.x, 480.0);
	
	if backgrounds.has(playerPos - backgroundWidth * 2):
		backgrounds[playerPos - backgroundWidth * 2].queue_free();
		backgrounds.erase(playerPos - backgroundWidth * 2);
	
	if !backgrounds.has(playerPos - backgroundWidth):
		var newBG = testBG.instantiate();
		add_child(newBG);
		backgrounds[playerPos - backgroundWidth] = newBG;
		newBG.position.x = playerPos - backgroundWidth;
		
	if !backgrounds.has(playerPos):
		var newBG = testBG.instantiate();
		add_child(newBG);
		backgrounds[playerPos] = newBG;
		newBG.position.x = playerPos;
		
	if !backgrounds.has(playerPos + backgroundWidth):
		var newBG = testBG.instantiate();
		add_child(newBG);
		backgrounds[playerPos + backgroundWidth] = newBG;
		newBG.position.x = playerPos + backgroundWidth;
