extends Area3D

@export var movement_speed: float = 10.0
@export var rotation_speed: float = 3.0

@onready var sound = $AudioStreamPlayer3D

func _process(delta: float) -> void:
	rotate_y(delta * rotation_speed)

func _physics_process(delta: float) -> void:
	global_position.x -= movement_speed * delta

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
	
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var coinCounter = get_node("/root/Main/HUD/Control/MarginContainer/HBoxContainer/CoinCount")
		coinCounter.text = str(coinCounter.text.to_int() + 1)
		sound.play()
		await sound.finished
		queue_free()
