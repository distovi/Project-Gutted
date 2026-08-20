extends MoveableEntity

var player_inside: bool = false
var player

func _ready() -> void:
	model = $MeshInstance3D
	player = get_tree().get_first_node_in_group("player")
	entity_setup()

func _physics_process(delta: float) -> void:
	if player_inside:
		wander_timer.stop()
		if detect_node(player):
			navi_agent3d.set_target_position(player.position)
	else:
		if wander_timer.is_stopped() and navi_agent3d.is_navigation_finished():
			wander_timer.start()
	var direction = get_direction()
	rotate_to_target(delta)
	velocity = direction * speed
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		player_inside = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		player_inside = false
