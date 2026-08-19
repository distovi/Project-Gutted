class_name State extends Node

var layer_manager : Node
var player : CharacterBody3D

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
	
func transition_to(new_state_name: String) -> void:
	if layer_manager:
		layer_manager.change_state(new_state_name, self)
