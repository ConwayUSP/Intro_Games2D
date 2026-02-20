extends Node

var current_level_size = 11

func next_level():
	current_level_size += 4
	get_tree().change_scene_to_file("res://world.tscn")
