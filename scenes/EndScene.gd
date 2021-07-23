extends Control

const scroll_speed: float = 120.0
var food_tscn: PackedScene = preload("res://objects/Food.tscn")

func _ready():
	$Villager.locked = true
	$Villager.drop_food_timer.stop()
	$Villager.wait_timer.stop()
	$Villager.move_speed = 0.0
	$Villager.direction = Vector2.DOWN
	$Music.set_volume_db(global.volume)
	$Music.play(global.music_time)

func _process(delta):
	$Background.position.y -= scroll_speed * delta
	$Background2.position.y -= scroll_speed * delta
	if $Background.position.y <= -320 + scroll_speed * delta:
		$Background.position.y = 320
	if $Background2.position.y <= -320 + scroll_speed * delta:
		$Background2.position.y = 320
	if has_node("CanvasLayer/Authors"):
		$CanvasLayer/Authors.rect_position.y -= scroll_speed * delta * 10
		if $CanvasLayer/Authors.rect_position.y < -1000:
			$CanvasLayer/Authors.queue_free()
			$CanvasLayer/DialogWindow.visible = true

func _on_Continue_pressed():
	global.continue_game = true
	global.music_time = $Music.get_playback_position()
	get_tree().change_scene_to(global.game)

func _on_Exit_pressed():
	get_tree().change_scene_to(global.start_menu)
