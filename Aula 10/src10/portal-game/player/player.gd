extends CharacterBody3D

@export var portal_blue: Portal
@export var portal_orange: Portal

@onready var raycast: RayCast3D = $Head/Camera3D/RayCast3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle shooting
	if Input.is_action_just_pressed("fire_blue"):
		shoot_portal("blue")

	if Input.is_action_just_pressed("fire_orange"):
		shoot_portal("orange")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.01)
		$Head.rotate_x(-event.relative.y * 0.01)
		$Head.rotation.x = clamp($Head.rotation.x, -PI/2, PI/2)
		
		
func shoot_portal(type: String):
	if raycast.is_colliding():
		var point = raycast.get_collision_point()
		var normal = raycast.get_collision_normal()
		var collider = raycast.get_collider()

		# Don't place portals on physics objects or other portals
		if collider.is_in_group("portals"): return

		var target_portal = portal_blue if type == "blue" else portal_orange
		
		# If the portal is already at this location, "retract" it
		if target_portal.visible and target_portal.global_position.distance_to(point) < 0.5:
			target_portal.visible = false
		else:
			place_portal(target_portal, point, normal)

func place_portal(portal, point, normal):
	portal.visible = true
	portal.global_position = point
	
	# Align the portal with the wall normal
	# We want the portal's -Z (forward) to match the wall's normal
	if normal.is_equal_approx(Vector3.UP):
		portal.look_at(point - normal, Vector3.FORWARD)
	else:
		portal.look_at(point - normal, Vector3.UP)
	
	# Small offset to prevent Z-fighting with the wall
	portal.global_position += normal * 0.05
