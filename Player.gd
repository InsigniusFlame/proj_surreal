extends CharacterBody3D

@onready var cam_origin = $Node3D
@onready var audio_player = $AudioStreamPlayer3D;
@onready var camera = $Node3D/SpringArm3D
@onready var camera_act = $Node3D/SpringArm3D/Camera3D
@export var SPEED = 10.0

const JUMP_VELOCITY = 20
var temp = 0
var double_jump = 0
var in_air = true
var in_superjump = false
var health = 100
var falldmg_multiplier = 0
var in_gpound = false
var inquicksand
var floor_breakable = false
var camera_original_pos
var sanity = 10
var in_wallrun = 0
var score = 0
var combo = 0
var combo_multiplier= 1

@export var super_jump_power = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x))
		cam_origin.rotate_x(deg_to_rad(-event.relative.y))
		cam_origin.rotation.x = clamp(cam_origin.rotation.x,deg_to_rad(-70),deg_to_rad(90))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_original_pos = camera.position


func _physics_process(delta):
	sanity -= 0.000001

	if Input.is_action_just_pressed("heal") and score > 50:
		health += 25
		score -= 50
		sanity += 5
		
	if velocity.y < -50:
		floor_breakable = true
	
	elif velocity.y > -50 and temp < -50:
		floor_breakable = true
	else:
		floor_breakable = false
	
			
	if not is_on_floor():
		velocity.y -= gravity * delta * 5
		in_air = true


	# Handle Jump.
	if Input.is_action_just_pressed("jump") and double_jump < 1: # idk why but this works
		velocity.y = JUMP_VELOCITY
		double_jump += 1
		in_air = true
	if is_on_floor():
		double_jump = 0
		in_air = false
		in_superjump = false
		in_gpound = false
		health -= falldmg_multiplier * 25

		
	# FALL DAMAGE
	if velocity.y < -80 and velocity.y > -100:
		falldmg_multiplier = 1
		camera.position += Vector3(randf_range(-0.1,0.1),randf_range(-0.5,0.5),randf_range(-0.1,0.1))
	elif velocity.y < -100:
		falldmg_multiplier= 2
		camera.position += Vector3(randf_range(-0.1,0.1),randf_range(-0.7,0.7),randf_range(-0.1,0.1))
	elif velocity.y < 1 and velocity.y > -1:
		falldmg_multiplier= 0
		camera.position = camera_original_pos
		
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if not in_superjump:
		if direction:
			velocity.x = move_toward(velocity.x,SPEED * direction.x, 1)
			velocity.z = move_toward(velocity.z,SPEED * direction.z  , 1)
		else:
			velocity.x = 0
			velocity.z = 0
	else:
		velocity.x = move_toward(velocity.x,direction.x*SPEED ,1)
		velocity.z = move_toward(velocity.z,direction.z*SPEED ,1)


		
		# SUPER JUMP
	if Input.is_action_pressed("sprint") and !(inquicksand):
		super_jump_power += 0.05
		super_jump_power = clamp(super_jump_power,0,5)

	if is_on_floor() and Input.is_action_just_released("sprint") and !(inquicksand):
		velocity.y = JUMP_VELOCITY * super_jump_power
		velocity.x = velocity.x * super_jump_power
		velocity.z = velocity.z * super_jump_power
		super_jump_power = 0
		in_air = true
		in_superjump = true
		var crash_sound = load("res://Stone breaking sound effect (no copyright).wav")
		audio_player.stream = crash_sound
		audio_player.play()
		
	if Input.is_action_just_pressed("G_pound") and in_air and not in_gpound:
		if velocity.y < 0:
			velocity.y += -50
		else:
			velocity.y = -50
		in_gpound = true
	if in_air:
		combo_multiplier += 0.5
	
	if health <= 0:
		get_tree().change_scene_to_file("res://gameoverscreen.tscn")
	temp = velocity.y
	if combo > 3:
		combo_multiplier = 2
	elif combo > 7:
		combo_multiplier = 4
	if velocity != Vector3(0,0,0) and ((abs(velocity.x) > 6 or abs(velocity.y) > 30 or abs(velocity.z) > 6)):
		combo += 0.01 * (combo_multiplier * in_wallrun) + (abs(velocity.y)/2000 + abs(velocity.x)/3000) + abs(velocity.z)/3000

	elif !(in_air) and (abs(velocity.x) < 6 and abs(velocity.y) <30):
		score += combo
		combo = 0
		
	if health > 100:
		health -= 0.01

	move_and_slide()
	
