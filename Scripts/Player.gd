extends CharacterBody2D
class_name Player
static var Instance;

@onready var collider = $CollisionShape2D;

@onready var Running = $Running;
@onready var Jumping = $Jumping;
@onready var Sliding = $Slide;

var runningLast = 8;

var slideFreeze = 2;
var slideLast = 4;

var jumpFreeze = 3;
var jumpLast = 3;

var frameRate = 12;
var animTimer = 0;

@export var acceleration = 500; #idk placeholder
@export var speed = 250;
@export var gravity = 1500; # guess
@export var crouchLength = 1; #how long, in seconds
@export var jumpHeight = 64; #how high, in pixels
@export var jumpSpeed = 5; #larger is faster

var jumping : bool = false;
var groundLastJump = false;
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
		collider.shape.size.y = 32;
		collider.position.y = -16;
		crouchTimer += delta;
		velocity.x *= 1 + (1 - crouchTimer) / 5;
		
		if crouchTimer >= crouchLength:
			crouched = false;
			collider.shape.size.y = 64;
			collider.position.y = -32;
			crouchTimer = 0;
	else:
		collider.shape.size.y = 64;
		collider.position.y = -32;
		velocity.x = velocity.x;
	
	if !jumping && is_on_floor():
		groundLastJump = true;
		
	if is_on_floor() && Input.is_action_pressed("ui_up"):
		groundLastJump = false;
		Jumping.frame = 0;
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
	animate(delta);


func animate(delta):
	animTimer += delta;
	var frameChange = floor(animTimer / (1.0 / frameRate));
	animTimer -= frameChange * (1.0 / frameRate);
	
	if jumping || !groundLastJump:
		Jumping.frame += frameChange;
		if !groundLastJump:
			Jumping.frame = min(Jumping.frame, jumpFreeze);
		
		Jumping.visible = true;
		Sliding.visible = false;
		Running.visible = false;
		Running.frame = 0;
		Sliding.frame = 0;
	elif crouched || Sliding.frame >= slideFreeze:
		Sliding.frame += frameChange;
		
		if crouched:
			Sliding.frame = min(Sliding.frame, slideFreeze);
		elif Sliding.frame > slideLast:
			Sliding.frame = 0;
			animate(0);
		
		Jumping.visible = false;
		Sliding.visible = true;
		Running.visible = false;
		Running.frame = 0;
		Jumping.frame = 0;
	else:
		Running.frame = fmod((Running.frame + frameChange), runningLast);
		
		Jumping.visible = false;
		Sliding.visible = false;
		Running.visible = true;
		Sliding.frame = 0;
		Jumping.frame = 0;
