extends Node3D

@onready var spawn_timer = $Timer
@export var entity_scene: PackedScene
@export var entity_folder: Node3D
@export var enable: bool = true
@export var light_color: Color
@export var spawn_time: float = 20

func _ready():
	$SpotLight3D.light_color = light_color
	spawn_entity()
	spawn_timer.wait_time = randf_range(spawn_time - 1, spawn_time + 3)
	spawn_timer.start()

func spawn_entity():
	if !enable:
		return
	var entity = entity_scene.instantiate()
	entity.name = entity.name + str(entity_folder.get_child_count())
	entity.position = self.position - Vector3(0,6,0)
	entity_folder.add_child(entity)

func _on_timer_timeout() -> void:
	spawn_entity()
