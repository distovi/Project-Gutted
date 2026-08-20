extends MoveableEntity

var threat_inside: bool = false
var threats: Array[CharacterBody3D] = []
@export var distance = 5

func _ready() -> void:
	model = $WildHare
	entity_setup()

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
			threat_center /= threat_count
			
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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("threat"):
		threat_inside = true
		threats.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("threat") and threats.count(body) < 1:
		threat_inside = false
	if body.is_in_group("threat"):
		threats.erase(body)
