class_name HealthComponent extends Node

signal health_changed(new_health: int)
signal died()

@onready var invincibility_timer: Timer = $InvincibleTimer
var is_invincible := false

@export var max_health: int = 100
var current_health: int = 100
@export var invincibility_time: float = 0.5

func _ready() -> void:
	invincibility_timer.wait_time = invincibility_time
	current_health = max_health

func _physics_process(delta: float) -> void:
	if current_health <= 0: 
		current_health = 0 
		died.emit()
		return

func damage(amount: int) -> void:
	if is_invincible: return
	is_invincible = true
	invincibility_timer.start()
	current_health -= amount
	health_changed.emit(current_health)

func heal(amount: int) -> void:
	var old_health = current_health
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health)

func get_health_percentage() -> float:
	return float(current_health) / float(max_health)

func is_alive() -> bool:
	return current_health > 0

func _on_invincible_timer_timeout() -> void:
	is_invincible = false
