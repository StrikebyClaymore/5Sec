extends Control

var speed_vector = Vector2()
var pressed: bool = false


func _ready() -> void:
	if global.platform == 2:
		visible = true
	else:
		set_process_input(false)
	pass

func _input(ev):
	#if get_parent().lock: return
	if ev is InputEventMouseButton or ev is TouchScreenButton:
		pressed = ev.pressed
		global.player.direction = Vector2.ZERO
	if pressed and (ev is InputEventMouseMotion or ev is InputEventScreenDrag):
		var pos = ev.position * Vector2(0.75, 0.75) / Vector2(1.125, 1.125)
		var size = $Disk.texture.get_data().get_size()*$Disk.scale
		var c_size = $Controller.texture.get_data().get_width()*$Controller.scale.x
		var dir = ($Disk.position - pos).normalized()
		var dist = pos.distance_to($Disk.position)
		
		if dist <= 46+32 - c_size/2:#size.x/2: # WHAT THE SHIT CODE??? FIX IT
			$Controller.position = pos
			speed_vector = dir*dist
		else:
			#if pos.distance_to($Disk.position) >= size.x/2 + 32:
			#	speed_vector = Vector2()
			#	return
			$Controller.position = pos + dir*pos.distance_to($Disk.position) - size/3*dir
			#speed_vector = dir * size.x/2
			dist = size.x/2
			speed_vector = dir*dist#($Disk.position - pos).normalized() * size.x/2
		global.player.direction = -dir
