extends Node2D
class_name Food

onready var tween: Tween = $Tween
onready var timer: Timer = $Timer
var hp: int = 5

var birds: Array = []


func init(dir: = Vector2(0, 0)):
	
	$Sprite.frame = randi()%63
	
	tween.interpolate_property(self, "position",
								position, position + Vector2(0, 8) + dir*Vector2(-16,0), 0.3,
								Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func on_hit(dmg:int) -> void:
	hp = max(0, hp - dmg)
	modulate.a -= float(dmg) / 10.0
	if hp == 0:
		remove_on_bird()
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Player:
		get_tree().current_scene.eat_food(1)
		remove_on_bird()
		queue_free()
	if body is Bird:
		remove_on_bird()
		queue_free()
	else:
		on_hit(3)

func remove_on_bird():
	for bird in birds:
		bird.back_to_roof()

func _on_Timer_timeout():
	on_hit(1)

func _on_Tween_tween_all_completed():
	$Area2D/CollisionShape2D.disabled = false
	timer.start()
