extends WorldEnvironment

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if $HUD/Control/StartMessage.visible:
			start_game()
		elif $HUD/Control/RestartMessage.visible:
			get_tree().reload_current_scene()

func start_game():
	$HUD/Control/StartMessage.hide()
	
	$Player.show()
	$Player.process_mode = Node.PROCESS_MODE_INHERIT
	$Spawner.process_mode = Node.PROCESS_MODE_INHERIT
