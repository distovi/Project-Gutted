class_name MoveableEntity extends CharacterBody3D

@onready var navi_agent3d: NavigationAgent3D = $NavigationAgent3D
@onready var wander_timer = $WanderTimer
var model
@export var wander_radius: float = 5.0
@export var turn_speed := 5
@export var speed:int = 4
var rand_pos

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func detect_node(target: Node3D) -> bool:
	if target == null:
		return false
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,target.global_position)
	query.exclude = [get_rid()]
	query.collision_mask = 2
	var result = space_state.intersect_ray(query)
	if result.collider == target:
		return true
	return false

func _on_wander_timer_timeout() -> void:
	rand_pos = Vector3.ZERO
	rand_pos.x = randf_range(global_position.x - wander_radius, global_position.x + wander_radius)
	rand_pos.z = randf_range(global_position.z - wander_radius, global_position.z + wander_radius)
	navi_agent3d.set_target_position(rand_pos)

func get_direction() -> Vector3:
	var destination = navi_agent3d.get_next_path_position()
	var distance_to_dest = (destination - global_position).length()
	if distance_to_dest < 0.1:
		return Vector3.ZERO
	var direction = (destination - global_position).normalized()
	return direction

func rotate_to_target(delta) -> void:
	var direction = get_direction()
	var target_angle = atan2(direction.x, direction.z)
	model.rotation.y = lerp_angle(model.rotation.y, target_angle, turn_speed * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	pass

func _on_area_3d_body_exited(body: Node3D) -> void:
	pass

func entity_setup() -> void:
	_on_wander_timer_timeout()
	wander_timer.wait_time = randf_range(wander_timer.wait_time - 1, wander_timer.wait_time + 3)
	wander_timer.start()
