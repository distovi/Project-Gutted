class_name Player extends CharacterBody3D

@onready var camera = $CameraPos
@onready var hud = $HUD/Labels
@onready var jump_buffer = $JumpBuffer
@onready var collision = $CollisionShape3D
@onready var health = $HealthComponent

@export var walk_speed = 4
@export var run_speed = 12
@export var crouch_speed = 2.5
var speed = 0

var crouching: bool = false

@export var friction = 0.25

@export var jump_height: float = 26
var jump_peak: float = 0.32
var jump_descent: float = 0.26
var jump_velocity = 4.5

var desired_velocity: Vector3

func _ready() -> void:
	health.died.connect(_on_died)
	health.health_changed.connect(_on_health_changed)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_TAB and event.pressed:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.y -= event.relative.x
		camera.rotation_degrees.x -= event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
		
func _physics_process(delta: float) -> void:
	movement(delta)
	move_and_slide()

func movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("Jump"):
		jump_buffer.start()
	if jump_buffer.time_left > 0: #and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_pressed("Crouch"):
		collision.shape.height = lerpf(2, 1, 0.25)
		camera.position.y = 0.25
	else:
		collision.shape.height = lerpf(collision.shape.height, 2, 0.25)
		camera.position.y = 0.5
	if Input.is_action_pressed("Sprint"):
		speed = run_speed
	elif Input.is_action_pressed("Crouch"):
		crouching = true
		speed = crouch_speed
	else:
		crouching = false
		speed = walk_speed
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backwards")
	var forward = camera.global_transform.basis.z
	var right = camera.global_transform.basis.x

	forward.y = 0; right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var direction = (forward * input_dir.y + right * input_dir.x).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = lerpf(velocity.x, 0, friction)
		velocity.z = lerpf(velocity.z, 0, friction)

func _on_died() -> void:
	queue_free()

func _on_health_changed(new_health: int) -> void:
	print("Health: ", new_health)

func _on_heal(new_health: int):
	pass
