extends Area3D

var parent_portal: Portal

func _ready():
	parent_portal = get_parent() as Portal
	if parent_portal == null:
		push_error("The PortalTeleport \"%s\" is not a child of a Portal instance" % name)
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if parent_portal.exit_portal.visible == false:
		return

	if body.get_meta("teleportable") == true:
		var exit = parent_portal.exit_portal.get_node("Exit")
		if exit == null:
			push_error("No Exit in exit portal for portal")

		body.global_transform = parent_portal.real_to_exit_transform(body.global_transform, exit.global_transform)
