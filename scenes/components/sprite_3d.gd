extends Sprite3D

@onready var timer = $Timer

func _ready() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	if frame == 66:
		frame = 0
	else:
		frame += 1
