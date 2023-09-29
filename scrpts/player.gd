extends CharacterBody2D



@export var max_speed = 1
@export var accel = 0.4
@export var deaccel = 0.8
@export var lerp_factor = 0.1

var speed = 0
var current_direction = Vector2.ZERO
#var _direction = Vector2.ZERO

var input = {
	"left_joystick":{
		"vector":Vector2.ZERO,
		"pressed":false,
		"shoot":false
	},
	"right_joystick":{
		"vector":Vector2.ZERO,
		"pressed":false,
		"shoot":false
	}
}

@onready var gun_node = $guns
@onready var l_contro = $camera/joystick/left_button
@onready var r_contro = $camera/joystick/right_button

func _physics_process(delta):
	read_input()
	process_input(input)
	pass
	
func read_input():
	input["left_joystick"]["vector"] = l_contro.find_vector()
	input["left_joystick"]["pressed"] = l_contro.find_pressed()
	input["left_joystick"]["shoot"] = l_contro.find_shooting()
	
	input["right_joystick"]["vector"] = r_contro.find_vector()
	input["right_joystick"]["pressed"] = r_contro.find_pressed()
	input["right_joystick"]["shoot"] = r_contro.find_shooting()
	
	
	
func process_input(input,reconcilating = false):
	if(reconcilating == false):
		if(input["right_joystick"]["pressed"]):
			gun_node.look_at(gun_node.global_position + input["right_joystick"]["vector"])
		var new_direc
		if(input["left_joystick"]["pressed"] and (input["left_joystick"]["shoot"])):
			new_direc = input["left_joystick"]["vector"]
			new_direc = new_direc.normalized()
			speed = min(speed+accel,max_speed)
			
			#var new_camera_pos = new_camera_pos.normalized()*3 
		elif(input["left_joystick"]["pressed"] and (!input["left_joystick"]["shoot"])):
			new_direc = input["left_joystick"]["vector"]
			new_direc = new_direc.normalized()
			speed = 0
		else:
			new_direc = Vector2.ZERO
			var new_camera_pos = Vector2.ZERO
			$camera.position = lerp($camera.position,new_camera_pos,0.2)
			speed = max(0,speed-deaccel)
		
		current_direction = lerp(current_direction,new_direc,lerp_factor)
		current_direction = current_direction.normalized()
		velocity = current_direction * speed
		move_and_slide()	
		## no need to implement this code on server
		if(input["right_joystick"]["pressed"]):
			var new_camera_pos = input["right_joystick"]["vector"]
			new_camera_pos = new_camera_pos/2
			$camera.position = lerp($camera.position,new_camera_pos,0.1)
		else:
			var new_camera_pos = Vector2.ZERO
			$camera.position = lerp($camera.position,new_camera_pos,0.2)
		pass
	pass
	

