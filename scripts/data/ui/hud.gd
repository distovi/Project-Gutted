extends Control

@onready var velocity = $Velocity
var text: String

func _ready() -> void:
	text = velocity.text

func _update_text(value):
	velocity.text = text + " " + str(value)
