extends Control


func _on_Start_pressed():
	get_tree().change_scene_to(global.game)

func _on_Settings_pressed():
	$SettingsMenu.visible = true

func _on_LookAuthors_pressed():
	$Authors.visible = true

func _on_Back_pressed():
	$Authors.visible = false
