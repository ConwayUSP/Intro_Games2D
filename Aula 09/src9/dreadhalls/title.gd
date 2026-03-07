extends Control

# Caminho para nossa cena principal
@export_file("*.tscn") var main_game_scene: String = "res://world.tscn"

func _ready():
	# Mantém o mouse está visível
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Seleciona o foco no botão por padrão.
	$GridContainer/Subtitle.grab_focus()

func _input(event):
	# Se apertar Enter ou clicar no botão, o jogo começa
	if event.is_action_pressed("ui_accept"):
		start_game()

func _on_play_button_pressed():
	start_game()

func start_game():
	# Dica: edite Manager aqui, se você quer mudar o estado incial do jogo ou carregar um save.
	# Começa o jogo.
	get_tree().change_scene_to_file(main_game_scene)
