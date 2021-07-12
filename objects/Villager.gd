extends Character
class_name Villager

const food_tscn: PackedScene = preload("res://objects/Food.tscn")
onready var drop_food_timer: Timer = $DropFoodTimer
onready var wait_timer: Timer = $WaitTimer

var wait: bool = false


func _ready():
	drop_food_timer.wait_time = 2 + randi()%8 + randf()
	drop_food_timer.start()
	wait_timer.wait_time = 3 + randi()%5 + randf()
	wait_timer.start()
	pass

func _physics_process(delta):
	move_process(delta)

func move_process(delta: float) -> void:
	if direction == Vector2.ZERO or wait:
		stop_anim()
		return
	move_and_collide((direction * move_speed).clamped(move_speed) * delta)
	play_anim()

func _on_DropFoodTimer_timeout():
	var f = food_tscn.instance()
	f.position = position + Vector2(0, -8)
	get_tree().current_scene.add_child(f)
	if wait:
		f.init(direction)
	else:
		f.init()
	drop_food_timer.wait_time = 2 + randi()%8 + randf()
	drop_food_timer.start()

func _on_WaitTimer_timeout():
	if bool(int(round(randf()))):
		wait = not wait
		if wait:
			drop_food_timer.stop()
			drop_food_timer.wait_time = 2 + randi()%8 + randf()
			drop_food_timer.start()
	wait_timer.wait_time = 3 + randi()%3 + randf()
	wait_timer.start()
