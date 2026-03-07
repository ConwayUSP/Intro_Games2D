extends MeshInstance3D
class_name Portal

@export var fade_out_distance_max: float = 10
@export var fade_out_distance_min: float = 8
@export var fade_out_color: Color = Color.WHITE

@export_range(0.0, 0.5, 0.1) var border_thickness: float = 0.05
@export_range(0.0, 0.2, 0.1) var border_softness: float = 0.02
@export_range(0.0, 10.0, 0.1) var glow_intensity: float = 2.0

@export var exit_portal: Portal
@export var portal_shader: Shader = preload("res://portal/Portal.gdshader")
@export var main_camera: Camera3D

@onready var exit_camera: Camera3D = $SubViewport/Camera3D
@onready var viewport: SubViewport = $SubViewport
@onready var exit_scale = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not (portal_shader and main_camera):
		push_error("No portal shader or main camera")
	
	if exit_portal == null:
		visible = false
		set_process(false)
		return
	
	material_override = ShaderMaterial.new()
	material_override.shader = portal_shader
	material_override.set_shader_parameter("fade_out_distance_max", fade_out_distance_max)
	material_override.set_shader_parameter("fade_out_distance_min", fade_out_distance_min)
	material_override.set_shader_parameter("fade_out_color", fade_out_color)   
	
	material_override.set_shader_parameter("border_thickness", border_thickness)
	material_override.set_shader_parameter("border_softness", border_softness)
	material_override.set_shader_parameter("glow_intensity", glow_intensity)

	material_override.set_shader_parameter("albedo", viewport.get_texture())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	exit_camera.global_transform = real_to_exit_transform(main_camera.global_transform, exit_portal.global_transform)
	

func real_to_exit_transform(real: Transform3D, other: Transform3D) -> Transform3D:
	# Convert from global space to local space at the entrance (this) portal
	var local:Transform3D = global_transform.affine_inverse() * real
	# Compensate for any scale the entrance portal may have
	var unscaled:Transform3D = local.scaled(global_transform.basis.get_scale())
	# Flip it (the portal always flips the view 180 degrees)
	var flipped:Transform3D = unscaled.rotated(Vector3.UP, PI)
	# Apply any scale the exit portal may have (and apply custom exit scale)
	var exit_scale_vector:Vector3 = other.basis.get_scale()
	var scaled_at_exit:Transform3D = flipped.scaled(Vector3.ONE / exit_scale_vector * exit_scale)
	# Convert from local space at the exit portal to global space
	var local_at_exit:Transform3D = other * scaled_at_exit
	return local_at_exit
