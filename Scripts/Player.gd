extends CharacterBody2D
class_name Player
static var Instance;

@onready var colliderHelper = $CollisionShape2D;

@onready var Running = $Running;
@onready var Jumping = $Jumping;
@onready var Sliding = $Slide;
@onready var Stumble = $Stumble;
@onready var Collect = $Collect;
@onready var Win = $Win;

var runningLast = 8;

var slideFreeze = 2;
var slideLast = 4;

var jumpFreeze = 3;
var jumpLast = 3;

var frameRate = 12;
var animTimer = 0;

@export var acceleration = 500;
@export var speed = 250;
var halfSpeed = 0;
@export var gravity = 1500; # guess
@export var crouchLength = 1; #how long, in seconds
@export var jumpHeight = 72; #how high, in pixels
@export var jumpSpeed = 5; #larger is faster

var jumping : bool = false;
var groundLastJump = false;
var jumpTime = 0;
var jumpY = 0;
var lastJump = 0;
var jumps = 2;
var maxJump = 1;
@onready var jumpSounds = [$Jump, $Soda];

var crouchTimer = 0;
var crouched = false;

@onready var collision = $"Collision Check";
@onready var collisionShape = $"Collision Check/CollisionShape2D";

@onready var headCollision = $"Head Check";
@onready var headCollisionShape = $"Head Check/CollisionShape2D";

var slowdownTimer = 0;
var slowdown = false;
var stumbling = false;
var slowdownLength = 2;

var collecting = false;

var coyoteTimer = 0;
var coyoteTime = 0.2;

@onready var hurtSound = $Hurt;
@onready var battSound = $Batt;
@onready var slideSound = $Slide2;

var playStart = false;
var playWin = false;


func _ready():
	if !Instance:
		Instance = self;
	else:
		queue_free();
		
	halfSpeed = speed / 2;

func _process(delta):
	if playWin:
		winAnim(delta);
		return;
		
	if playStart:
		startAnim(delta);
		return;
		
		
	maxJump = 2 if Game.Instance.soda else 1;
	
	velocity.x += acceleration * delta;
	velocity.x = min(velocity.x, speed);
	velocity.y += gravity * delta;
	
	collision.position.y = colliderHelper.position.y;
	collision.position.x = colliderHelper.shape.size.x / 2;
	collisionShape.shape.size.y = colliderHelper.shape.size.y * 0.9;
	
	headCollision.position.y = colliderHelper.position.y - colliderHelper.shape.size.y / 2;
	headCollisionShape.shape.size.x = colliderHelper.shape.size.x;
	
	if Input.is_action_just_pressed("ui_down") && !crouched && Game.Instance.socks && (is_on_floor() || coyoteTimer <= coyoteTime):
		crouched = true;
		slideSound.play(0.0);
	
	if crouched:
		colliderHelper.shape.size.x = 60;
		colliderHelper.shape.size.y = 14;
		colliderHelper.position.y = -7;
		crouchTimer += delta;
		if !slowdown:
			velocity.x *= 1# + (1 - crouchTimer) / 5;
		
		if crouchTimer >= crouchLength:
			crouched = false;
			colliderHelper.shape.size.x = 32;
			colliderHelper.shape.size.y = 64;
			colliderHelper.position.y = -32;
			crouchTimer = 0;
	else:
		colliderHelper.shape.size.x = 32;
		colliderHelper.shape.size.y = 64;
		colliderHelper.position.y = -32;
	
	if !jumping && is_on_floor():
		groundLastJump = true;
		
	if !is_on_floor():
		coyoteTimer += delta;
	else:
		coyoteTimer = 0;
		
	if Input.is_action_just_pressed("ui_up") && jumps > 0 && ((jumps != maxJump || (is_on_floor() || coyoteTimer <= coyoteTime)) || maxJump == 2):
		groundLastJump = false;
		jumping = true;
		Jumping.frame = 0;
		jumping = true;
		jumpTime = 0;
		jumpY = position.y;
		if crouched:
			slideSound.stop();
		crouched = false;
		crouchTimer = 0;
		if !is_on_floor() && jumps == 2:
			jumps -= 1
			
		jumps -= 1;
			
		if jumps == 0 && maxJump == 2:
			jumpSounds[1].play();
		else:
			jumpSounds[0].play();
			

		
	if is_on_floor() && !Input.is_action_just_pressed("ui_up"):
		jumps = 2 if Game.Instance.soda else 1;
	
	if jumping:
		lastJump = -sin(jumpTime * jumpSpeed);
		jumpTime += delta;
		position.y = -sin(jumpTime * jumpSpeed) * jumpHeight + jumpY;
		velocity.y = -sin(jumpTime * jumpSpeed) * jumpHeight;
		
	if !Input.is_action_pressed("ui_up") || (is_on_floor() && jumpTime > 0.1) || lastJump < -sin(jumpTime * 5) || headCollision.get_overlapping_bodies().size() > 0:
		jumping = false;
	
	if velocity.y > 0 && !is_on_floor() && groundLastJump:
		groundLastJump = false;
		Jumping.frame = 2;
	
	if slowdown:
		speed = halfSpeed;
		slowdownTimer -= delta;
		set_collision_mask_value(2, false)
	else:
		speed = halfSpeed * 2;
		set_collision_mask_value(2, true)
	
	Running.self_modulate = Color(1.0, 1.0, 1.0, cos(slowdownTimer * 25) / 4 + 0.75);
	Jumping.self_modulate = Color(1.0, 1.0, 1.0, cos(slowdownTimer * 25) / 4 + 0.75);
	Sliding.self_modulate = Color(1.0, 1.0, 1.0, cos(slowdownTimer * 25) / 4 + 0.75);
	
	if slowdownTimer <= 0 && collision.get_overlapping_bodies().size() == 0:
		slowdown = false;
	
	move_and_slide();
	
	if position.x >= 12356:
		position.x -= 13232;
	
	CameraController.Instance.position.x = position.x + 40;
	animate(delta);
	

func animate(delta):
	animTimer += delta;
	var frameChange = floor(animTimer / (1.0 / frameRate));
	animTimer -= frameChange * (1.0 / frameRate);
	
	if collecting:
		var frame = Collect.frame + frameChange;
		if frame == 5:
			collecting = false;
			animate(0);
		
		Collect.frame = frame;
		
		Jumping.visible = false;
		Sliding.visible = false;
		Running.visible = false;
		Stumble.visible = false;
		Collect.visible = true;
		Sliding.frame = 0;
		Jumping.frame = 0;
		Running.frame = 0;
		Stumble.frame = 0;
	elif stumbling:
		var frame = Stumble.frame + frameChange;
		if frame == 7:
			stumbling = false;
			animate(0);
		
		Stumble.frame = frame;
		
		Jumping.visible = false;
		Sliding.visible = false;
		Running.visible = false;
		Stumble.visible = true;
		Collect.visible = false;
		Sliding.frame = 0;
		Jumping.frame = 0;
		Running.frame = 0;
		Collect.frame = 0;
	elif jumping || !groundLastJump:
		Jumping.frame += frameChange;
		if !groundLastJump:
			Jumping.frame = min(Jumping.frame, jumpFreeze);
		
		if Jumping.frame == 2:
			colliderHelper.shape.size.y = 40;
			colliderHelper.position.y = -44;
		elif Jumping.frame == 3:
			colliderHelper.shape.size.y = 50;
			colliderHelper.position.y = -39;
		
		Jumping.visible = true;
		Sliding.visible = false;
		Running.visible = false;
		Stumble.visible = false;
		Collect.visible = false;
		Running.frame = 0;
		Sliding.frame = 0;
		Stumble.frame = 0;
		Collect.frame = 0;
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
		Stumble.visible = false;
		Collect.visible = false;
		Running.frame = 0;
		Jumping.frame = 0;
		Stumble.frame = 0;
		Collect.frame = 0;
	else:
		Running.frame = fmod((Running.frame + frameChange), runningLast);
		
		colliderHelper.shape.size.y = 64;
		colliderHelper.position.y = -32;
		
		Jumping.visible = false;
		Sliding.visible = false;
		Running.visible = true;
		Stumble.visible = false;
		Collect.visible = false;
		Sliding.frame = 0;
		Jumping.frame = 0;
		Stumble.frame = 0;
		Collect.frame = 0;


func _on_collision_check_body_entered(body):
	if !slowdown && headCollision.get_overlapping_bodies().find(body) == -1:
		slowdown = true;
		stumbling = true;
		slowdownTimer = slowdownLength;
		Monst.Instance.nyoom();
		hurtSound.play();


func _on_head_check_body_entered(body):
	if jumping:
		#jumping = false;
		print("head")
		#position.y = -lastJump * jumpHeight + jumpY;
	pass # Replace with function body.


var collectLoop = false;
var winAnimTimer = 0;
var moveTime = 1;
var movingMons = true;

func winAnim(delta):
	Jumping.visible = false;
	Sliding.visible = false;
	Running.visible = false;
	Stumble.visible = false;
	if !collectLoop:
		Collect.visible = false;
		Win.visible = true;
		
	if movingMons:
		moveTime -= delta;
		CameraController.Instance.position.x = lerp(position.x, position.x + 40, moveTime);
		
		if Win.frame < 2:
			animTimer += delta;
			var frameChange = floor(animTimer / (1.0 / frameRate));
			animTimer -= frameChange * (1.0 / frameRate);
			
			var frame = Win.frame + frameChange;
			
			Win.frame = clamp(frame, 0, 16);
		
		if moveTime <= 0:
			movingMons = false;
		return;
	
	animTimer += delta;
	var frameChange = floor(animTimer / (1.0 / frameRate));
	animTimer -= frameChange * (1.0 / frameRate);
	
	var frame = Win.frame + frameChange;
	
	Win.frame = clamp(frame, 0, 16);
	
	if frame == 14:
		Monst.Instance.amDie = true;
	
	if frame == 17 && !collectLoop:
		Collect.visible = true;
		Win.visible = false;
		collectLoop = true;
		frameRate *= 0.75;
		Collect.flip_h = true;
		
	if collectLoop:
		Collect.frame = fmod(Collect.frame + frameChange, 5.0);


func startAnim(delta):
	pass
