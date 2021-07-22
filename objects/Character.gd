extends KinematicBody2D
class_name Character

onready var animator: AnimationPlayer = $AnimationPlayer
onready var step_audio_player = $AudioStreamPlayer2D
var move_speed: float = 40.0
var direction: = Vector2()
var locked: bool = false
#var max_hp: int = 100
#var hp: int = 100


func play_anim() -> void:
	if direction.y >= 0:
		if direction.y > 0.5:
			animator.play("move_down")
		elif direction.x > 0.5:
			animator.play("move_right")
		else:
			animator.play("move_left")
	else:
		if direction.y < -0.5:
			animator.play("move_top")
		elif direction.x > 0.5:
			animator.play("move_right")
		else:
			animator.play("move_left")
	if not step_audio_player.playing:
		step_audio_player.play()

func stop_anim() -> void:
	animator.stop()
	$Sprite.frame_coords.x = 0
	step_audio_player.stop()

func set_front() -> void:
	$Sprite.frame_coords = Vector2(0, 0)

#func on_hit(dmg:int) -> void:
#	hp = max(0, hp - dmg)
#	if hp == 0:
#		queue_free()
