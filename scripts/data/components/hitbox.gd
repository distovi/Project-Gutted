extends Area3D

@export var damage_value: int = 10
var health_component

var inside := false
func _physics_process(delta: float) -> void:
	if inside:
		health_component.damage(damage_value)

func _on_hurt_box_body_entered(body: Node3D) -> void:
	if body.get_node_or_null("HealthComponent") != null:
		health_component = body.get_node("HealthComponent") as HealthComponent
		inside = true
		health_component.damage(damage_value)
	else:
		print("No HealthComponent found on: ", body.name)
		return


func _on_hurt_box_body_exited(body: Node3D) -> void:
	inside = false
