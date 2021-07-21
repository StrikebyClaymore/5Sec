extends Node

var start_menu: PackedScene = preload("res://scenes/StartMenu.tscn")
var game: PackedScene = preload("res://scenes/Level.tscn")
var volume: int = -30 setget set_volume
var music_time: float = 0.0
var world_day: int = 3
var first_play: bool = true


func set_volume(value:int) -> void:
	volume = value
	if get_tree().current_scene.has_node("Music"):
		get_tree().current_scene.get_node("Music").set_volume_db(volume) 

func bool_rand() -> bool:
	return bool(int(round(randf())))
