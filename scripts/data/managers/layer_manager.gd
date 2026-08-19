class_name LayerManager extends Node

@export var initial_state : String = "Idle"

var current_state : State = null
var previous_state : State = null
var state_dict : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			state_dict[child.name] = child
			child.layer_manager = self
			child.player = get_parent().get_parent()
			child.active = false

	if state_dict.has(initial_state):
		change_state(initial_state, null)

func change_state(new_state_name: String, caller: State) -> void:
	if not state_dict.has(new_state_name):
		return
	var new_state = state_dict[new_state_name]

	if new_state == current_state:
		return

	if current_state and current_state.has_method("can_exit"):
		if not current_state.can_exit(new_state):
			return

	if current_state:
		current_state.exit()

	current_state.set_process(false)
	current_state.set_physics_process(false)

	current_state = new_state
	current_state.set_process(true)
	current_state.set_physics_process(true)
	current_state.enter()


func get_state_data() -> Dictionary:
	if current_state and current_state.has_method("get_data"):
			return current_state.get_data()
	return {}
