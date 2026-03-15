extends CharacterBody3D

@export var movement_speed: float = 20.0

func _ready() -> void:
	rotate_y(-90.0)

func _physics_process(delta: float) -> void:
	global_position.x -= delta * movement_speed


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
