extends Control

var label_refs: Dictionary = {}

func _ready():
	register_all_labels()

func register_all_labels():
	for child in get_children():
		if child is Label:
			var key = child.name.to_lower()
			label_refs[key] = child

func has_label(label_name: String) -> bool:
	var key = label_name.to_lower()
	return label_refs.has(key)

func get_label(label_name: String) -> Label:
	var key = label_name.to_lower()
	if label_refs.has(key):
		return label_refs[key]
	return null

func update_text(parameter_name: String, value) -> bool:
	var key = parameter_name.to_lower()
	
	if not label_refs.has(key):
		print("Error: Label '", parameter_name, "' not found!")
		return false
	var label = label_refs[key]
	
	var value_str = _convert_to_string(value)
	label.text = value_str
	
	return true

# Set text with custom formatting
func set_formatted_text(parameter_name: String, value, format_string: String = "{value}") -> bool:
	var key = parameter_name.to_lower()
	
	if not label_refs.has(key):
		print("Error: Label '", parameter_name, "' not found!")
		return false
	
	var label = label_refs[key]
	var value_str = _convert_to_string(value)
	label.text = format_string.replace("{value}", value_str)
	return true

# Convert any value to string
func _convert_to_string(value) -> String:
	# Handle different types
	match typeof(value):
		TYPE_NIL:
			return "null"
		TYPE_BOOL:
			return "true" if value else "false"
		TYPE_INT, TYPE_FLOAT:
			return str(value)
		TYPE_STRING:
			return value
		TYPE_VECTOR2:
			return "(" + str(value.x) + ", " + str(value.y) + ")"
		TYPE_VECTOR3:
			return "(" + str(value.x) + ", " + str(value.y) + ", " + str(value.z) + ")"
		TYPE_COLOR:
			return "#" + value.to_html()
		TYPE_ARRAY:
			return str(value)
		TYPE_DICTIONARY:
			return str(value)
		_:
			return str(value)

func get_registered_labels() -> Array:
	return label_refs.keys()
