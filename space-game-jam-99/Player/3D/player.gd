extends CharacterBody3D

@export var speed := 6.0
@export var sprint_speed := 10.0
@export var jump_force := 5.5
@export var mouse_sensitivity := 0.15
@export var gravity := 20

@onready var head := $Head
@onready var cam := $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Gravité
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Déplacement
	var current_speed = speed
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed

	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()
