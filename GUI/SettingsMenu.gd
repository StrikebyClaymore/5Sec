extends Control


func _ready():
	$Volume/HSlider.value = global.volume

func _on_Back_pressed():
	visible = false

func _on_HSlider_value_changed(value):
	global.volume = int(value)

