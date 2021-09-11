extends Control


func _ready():
	#OS.window_fullscreen = true
	pass

func _on_Start_pressed():
	set_os()
	get_tree().change_scene_to(global.game)

func set_os() -> void:
	if not global.platform == global.platforms.NONE:
		return
	if OS.get_model_name() == "Android":
		global.platform = global.platforms.MOBILE
	else:
		global.platform = global.platforms.PC

func _on_Settings_pressed():
	$SettingsMenu.visible = true

func _on_LookAuthors_pressed():
	$Authors.visible = true

func _on_Back_pressed():
	$Authors.visible = false


func _on_PC_pressed() -> void:
	global.platform = global.platforms.PC
	$DeviceSetup/Mobile.pressed = false

func _on_Mobile_pressed() -> void:
	global.platform = global.platforms.MOBILE
	$DeviceSetup/PC.pressed = false
