extends CharacterBody2D
class_name Player

static var Instance;

@export var acceleration = 500; #idk placeholder
@export var speed = 250;
@export var gravity = 1500; # guess
@export var crouchLength = 1; #how long, in seconds
@export var jumpHeight = 64; #how high, in pixels
@export var jumpSpeed = 5; #larger is faster

var jumping : bool = false;
var jumpTime = 0;
var lastJump = 0;

var crouchTimer = 0;
var crouched = false;

func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();

func _process(delta):
	velocity.x += acceleration * delta;
	velocity.x = min(velocity.x, speed);
	velocity.y += gravity * delta;
	
	if Input.is_action_just_pressed("ui_down") && !crouched:
		crouched = true;
	
	if crouched:
		scale.y = 0.5;
		crouchTimer += delta;
		velocity.x *= 1 + (1 - crouchTimer) / 5;
		
		if crouchTimer >= crouchLength:
			crouched = false;
			scale.y = 1;
			crouchTimer = 0;
	else:
		scale.y = 1;
		velocity.x = velocity.x;
	
	if is_on_floor() && Input.is_action_pressed("ui_up"):
		jumping = true;
		jumpTime = 0;
		crouched = false;
		crouchTimer = 0;
	
	if jumping:
		lastJump = -sin(jumpTime * jumpSpeed);
		jumpTime += delta;
		position.y = -sin(jumpTime * jumpSpeed) * jumpHeight;
		velocity.y = position.y;
		
	if !Input.is_action_pressed("ui_up") || (is_on_floor() && jumpTime > 0.1) || lastJump < -sin(jumpTime * 5):
		jumping = false;
	
	move_and_slide();
	
	CameraController.Instance.position.x = position.x;
