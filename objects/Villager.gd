extends Character
class_name Villager

const food_tscn: PackedScene = preload("res://objects/Food.tscn")
onready var drop_food_timer: Timer = $DropFoodTimer
onready var wait_timer: Timer = $WaitTimer

var min_drop_food_time: int = 2
var drop_food_time: int = 8
var min_wait_time: int = 3
var wait_time: int = 5

var wait: bool = false


func _ready():
	set_timer_wait_time(drop_food_timer, min_drop_food_time, drop_food_time)
	drop_food_timer.start()
	set_timer_wait_time(wait_timer, min_wait_time, wait_time)
	wait_timer.start()

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
	set_timer_wait_time(drop_food_timer, min_drop_food_time, drop_food_time)
	drop_food_timer.start()

func _on_WaitTimer_timeout():
	if global.bool_rand():
		wait = not wait
		if wait:
			drop_food_timer.stop()
			set_timer_wait_time(drop_food_timer, min_drop_food_time, drop_food_time)
			drop_food_timer.start()
	set_timer_wait_time(wait_timer, min_wait_time, wait_time)
	wait_timer.start()

func set_timer_wait_time(timer:Timer, min_:int, time:int) -> void:
	timer.wait_time = min_ + randi()%time + randf()
