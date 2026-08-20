extends CharacterBody3D

@onready var navi_agent3d: NavigationAgent3D = $NavigationAgent3D
@onready var wander_timer = $WanderTimer
@export var model: MeshInstance3D

@export var wander_radius: float = 5.0

var turn_speed := 5
var rand_pos
var threat_inside: bool = false
var threats: Array[CharacterBody3D] = []
var distance = 5

@export var speed:int = 8

func _ready() -> void:
	_on_wander_timer_timeout()
	wander_timer.wait_time = randf_range(wander_timer.wait_time - 1, wander_timer.wait_time + 3)
	wander_timer.start()

func _physics_process(delta: float) -> void:
	if threat_inside:
		wander_timer.stop()
		var threat_center = Vector3.ZERO
		var threat_count = 0
		for threat in threats:
			if detect_node(threat):
				threat_center += threat.global_position
				threat_count += 1

		if threat_count > 0:
			threat_center /= threat_count  #average position
			
			var direction_away = (global_position - threat_center).normalized()
			var target_position = global_position + direction_away * distance
			navi_agent3d.set_target_position(target_position)
	else:
		if wander_timer.is_stopped() and navi_agent3d.is_navigation_finished():
			wander_timer.start()
	var direction = get_direction()
	rotate_to_target(delta)
	velocity = direction * speed
	move_and_slide()

func detect_node(target: Node3D) -> bool:
	if !target:
		return false
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position, target.global_position)
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
	var direction = (destination - global_position).normalized()
	return direction

func rotate_to_target(delta) -> void:
	var direction = get_direction()
	var target_angle = atan2(direction.x, direction.z)
	model.rotation.y = lerp_angle(model.rotation.y, target_angle, turn_speed * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	threat_inside = true
	if body.is_in_group("threat"):
		threats.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("threat") and threats.count(body) < 1:
		threat_inside = false
	if body.is_in_group("threat"):
		threats.erase(body)
