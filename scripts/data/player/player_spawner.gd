extends Node3D

@export var player_scene: PackedScene
@export var entity_folder: Node3D

func _ready():
	spawn_player()

func spawn_player():
	var player = player_scene.instantiate()
	player.position = self.position
	add_child(player)
