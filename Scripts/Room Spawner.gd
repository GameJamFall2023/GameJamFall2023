extends Node2D

# living room -> hallway -> dining/kitchen -> hallway -> loop
# bathroom and bedroom collectables

@onready var livingRoom = preload("res://Rooms/Living Room.tscn");
@onready var bedroom = preload("res://Rooms/Bedroom.tscn");
@onready var kitchenDining = preload("res://Rooms/Kitchen Dining.tscn");
@onready var hallway = preload("res://Rooms/Hallway.tscn");

var nextRoom = kitchenDining;
var currentRoom = livingRoom;
var nextRoomPosition = 1920;

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func pickNextRoom():
	if currentRoom == livingRoom && Game.Instance.batt1 && !Game.Instance.soda:
		nextRoom = bedroom;
	elif currentRoom == kitchenDining && Game.Instance.batt2 && !Game.Instance.soda:
		pass
