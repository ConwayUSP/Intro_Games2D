extends Area3D

@export var rotation_speed: float = 2.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	
	rotate_y(rotation_speed * delta)
	position.y = 1.0 + sin(Time.get_ticks_msec() * 0.005) * 0.2

func _on_body_entered(body: Node3D):
	if body.name == "Player":
		$AcquiredSound.play()
		await $AcquiredSound.finished
		Manager.next_level()
