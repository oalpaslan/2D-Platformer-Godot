extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 50
export(int) var JUMP_FORCE = -130  #Export: Editable in engine
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 50
export(int) var FRICTION = 10
export(int) var ACCELERATION = 10
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4
var double_jump = true 
onready var animatedSprite = $AnimatedSprite
var skins = ["res://assets/skins/PlayerGreenSkin.tres", "res://assets/skins/PlayerBlueSkin.tres"]
var playerSkin = 0

func _ready(): #Initialization function
	animatedSprite.frames = load("res://assets/skins/PlayerGreenSkin.tres")

func _input(event):
	if Input.is_key_pressed(KEY_P):
		
		playerSkin += 1
		if playerSkin == len(skins):
			playerSkin = 0
		animatedSprite.frames = load(skins[playerSkin])
		
		

func _physics_process(delta):  #delta is in seconds.
	apply_gravity()

	var input = Vector2.ZERO
	#get_action_strength: Gives the strength of the input.
	#It is 1 if a button is pressed, but changeable with controller sticks (if shifted a little, it can be between 0 and 1)
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle" 
		#$AnimatedSprite = Shorthand for get_node("AnimatedSprite")
		#"Idle" should have the same name with the name in animations
	else:
		apply_acceleration(input.x)
		if input.x < 0:
			animatedSprite.flip_h = false
		else:
			animatedSprite.flip_h = true
		animatedSprite.animation = "Run" 	
		
	if is_on_floor():
		double_jump = true
		if Input.is_action_just_pressed("ui_up"):  #is_on_floor: A KinematicBody2D method
			velocity.y = JUMP_FORCE  #Y is + if down, - if up
	else:
		animatedSprite.animation = "Jump"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE and double_jump == true:  #velocity.y < 0: only if going upwards
			velocity.y = JUMP_RELEASE_FORCE
		elif Input.is_action_just_pressed("ui_up") and double_jump == true:  #is_on_floor: A KinematicBody2D method
			velocity.y = JUMP_FORCE
			double_jump = false

		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY  #Increase speed while falling
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)	
	var just_landed = is_on_floor() and not was_on_floor #To see if the player has jumped before or not
	if just_landed:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1

func apply_gravity():
	velocity.y += GRAVITY


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)  #move_toward(from, to, delta: move amount)


func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)  #We use amount because if it is -1, it will move to the left
