extends CharacterBody3D

const SPEED = 10.0
@onready var animation: AnimationPlayer = $lameheli/AnimationPlayer

@onready var restart_screen = $/root/Main/HUD/Control/RestartMessage
@export var explosion_scene: PackedScene

func _ready():
	animation.play("Cube_001Action")

func _physics_process(delta: float) -> void:
	var direction = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("move_up"):
		direction.y += 1
	if Input.is_action_pressed("move_down"):
		direction.y -= 1

	velocity = direction * SPEED

	move_and_slide()	
	clamp_position()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var bumped_object = collision.get_collider()
		
		if bumped_object.is_in_group("obstacles"):
			die()

func clamp_position():
	var camera = get_viewport().get_camera_3d()
	
	var position_relative_to_camera = camera.global_transform.inverse() * global_position
	var z_depth = -position_relative_to_camera.z
	
	var upper_left = camera.project_position(Vector2(0, 0), z_depth)
	var bottom_right = camera.project_position(get_viewport().get_visible_rect().size, z_depth)
	
	position.y = clamp(position.y, bottom_right.y, upper_left.y)
	
func die():
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	
	hide()
	$CollisionShape3D.set_deferred("disabled", true)
	$CollisionShape3D2.set_deferred("disabled", true)
	restart_screen.show()
