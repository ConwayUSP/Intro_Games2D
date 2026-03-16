extends Node3D

@export var skycraper: PackedScene
@export var coin: PackedScene
@export var airplane: PackedScene


func spawn_object(scene: PackedScene, base_range_y: float, end_range_y: float):
	var instance = scene.instantiate()
	
	var random_y = randf_range(base_range_y, end_range_y)
	instance.position = Vector3(position.x, random_y, position.z)
	add_child(instance)

func _on_skyscraper_timer_timeout() -> void:
	var i = randi() % 10
	
	if i < 3:
		spawn_object(skycraper, -50, -40)


func _on_coin_timer_timeout() -> void:
	var i = randi() % 10
	
	if i < 5:
		spawn_object(coin, -20, 10)

func _on_airplane_timer_timeout() -> void:
	var i = randi() % 10
	
	if i < 3:
		spawn_object(airplane, 7, 10)
