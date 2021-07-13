extends Control


func _on_Start_pressed():
	get_tree().change_scene_to(global.game)
	pass

func _on_Settings_pressed():
	$SettingsMenu.visible = true
