extends Camera2D

var player: Player


func init(p:Player) -> void:
	player = p
	global_position = player.global_position

func _process(delta):
	var fps: = Engine.get_frames_per_second()
	var lerp_interval: = player.direction * player.move_speed / fps
	var lerp_position: = player.global_position + lerp_interval
	
	if fps > 60:
		set_as_toplevel(true)
		global_position = global_position.linear_interpolate(lerp_position, 50 * delta)
	else:
		global_position = player.global_position.round()
		#force_update_scroll()
		set_as_toplevel(false)
