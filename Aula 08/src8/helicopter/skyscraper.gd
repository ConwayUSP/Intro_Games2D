extends StaticBody3D

@export var movement_speed: float = 10.0

func _physics_process(delta: float) -> void:
	global_position.x -= delta * movement_speed

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
