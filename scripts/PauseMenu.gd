extends Control


func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().current_scene.set_pause()

func open_with_restart() -> void:
	$Panel/Resume.visible = false
	$Panel/Restart.visible = true
	visible = true

func _on_Resume_pressed():
	visible = false
	get_tree().paused = false

func _on_Restart_pressed():
	global.music_time = get_tree().current_scene.music.get_playback_position()
	#global.world_day = 1
	get_tree().paused = false
	get_tree().change_scene_to(global.game)

func _on_Settings_pressed():
	$SettingsMenu.visible = true

func _on_Exit_pressed():
	get_tree().paused = false
	global.world_day = 1
	get_tree().current_scene.queue_free()
	get_tree().change_scene_to(global.start_menu)


