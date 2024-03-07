extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 50

func _physics_process(delta): #delta is in seconds.
	apply_gravity()
	jump() 
	
	var input = Vector2.ZERO
	#get_action_strength: Gives the strength of the input. 
	#It is 1 if a button is pressed, but changeable with controller sticks (if shifted a little, it can be between 0 and 1)
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	
	if(input.x == 0):
		apply_friction()
	else:
		apply_acceleration(input.x)
		
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func apply_gravity():
	velocity.y += 8
	
func jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up") and is_on_floor(): #is_on_floor: A KinematicBody2D method
			velocity.y = -150 #Y is + if down, - if up
	else:
		if Input.is_action_just_released("ui_up"):
			velocity.y= 0
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, 10) #move_toward(from, to, delta: move amount)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, 50 * amount, 10) #We use amount because if it is -1, it will move to the left

