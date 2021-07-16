extends Node2D

onready var villagers: YSort = $YSort/Villagers
onready var villagers_spawn_timer: Timer = $VillagersSpawnTimer
onready var player: Player = $YSort/Player
onready var world_time_timer: Timer = $GUI/Time/Timer
onready var food: Node2D = $YSort/Food
const  villager_tscn: PackedScene = preload("res://objects/Villager.tscn")
const guardian_tscn: PackedScene = preload("res://objects/Guardian.tscn")
var spawn_points: Array = []
var satiety: int = 0
var world_time: Dictionary = { hour = 8, minut = 0 }
var start_day_time: String = "8:00"
var end_day_time: int = 18
var min_villagers_spawn_time: int = 1
var villagers_spawn_time: int = 3
var tween_type: String


func _ready():
	randomize()
	$Music.set_volume_db(global.volume)
	$GUI/PauseMenu/SettingsMenu/Volume/HSlider.value = global.volume
	$Music.play(global.music_time)
	$GUI/Time/Label.text = start_day_time
	spawn_points = $SpawnPoints.get_children()
	villagers_spawn_timer.start()
	world_time_timer.start()
	$GUI.scale *= 1.5
	get_tree().paused = true
	start_game()

func spawn_villager() ->  void:
	var v: Character = villager_tscn.instance()
	
	if randf() < 0.1:
		v = guardian_tscn.instance()
	
	if global.bool_rand():
		v.position.x = spawn_points[0].position.x
		v.position.y = rand_range(spawn_points[0].position.y, spawn_points[1].position.y)
		v.direction = Vector2.RIGHT
	else:
		v.position.x = spawn_points[2].position.x
		v.position.y = rand_range(spawn_points[2].position.y, spawn_points[3].position.y)
		v.direction = Vector2.LEFT
	add_villagers_colliding_exeption(v)
	villagers.add_child(v)

func eat_food(value:int) ->  void:
	satiety = min(100, satiety + value)
	update_gui()
	if $GUI/SatietyeProgress.value >= $GUI/SatietyeProgress.max_value:
		end_day()

func update_gui() -> void:
	$GUI/SatietyeProgress.value = satiety

func add_villagers_colliding_exeption(v: Character) -> void:
	player.add_collision_exception_with(v)
	v.add_collision_exception_with(player)
	for c in villagers.get_children():
		v.add_collision_exception_with(v)
		c.add_collision_exception_with(v)

func wasted() -> void:
	get_tree().paused = true
	$GUI/Wasted.visible = true
	start_tween("wasted")

func set_pause() -> void:
	$GUI/PauseMenu.visible = not $GUI/PauseMenu.visible
	get_tree().paused = not get_tree().paused

func update_world_time() -> void:
	world_time.minut += 10
	if world_time.minut >= 60:
		world_time.minut = 0
		world_time.hour += 1
	$GUI/Time/Label.text = str(world_time.hour) + ":" + str(world_time.minut)
	if world_time.minut == 0:
		$GUI/Time/Label.text += str(0)
	if world_time.hour == end_day_time:
		end_day()

func end_day() -> void:
	if $GUI/SatietyeProgress.value < $GUI/SatietyeProgress.max_value:
		$GUI/Time.visible = false
		wasted()
		return
	world_time_timer.stop()
	global.world_day += 1
	$GUI/Day/Label.text = "Day " + str(global.world_day)
	$GUI/Time.visible = false
	start_tween("end_day")
	global.music_time = $Music.get_playback_position()
	get_tree().paused = true

func start_game() -> void:
	if global.world_day == 1:
		$GUI/Day.visible = true
		start_tween("start_game", true)
	else:
		get_tree().paused = false

func start_tween(type:String, inverted:bool = false) -> void:
	tween_type = type
	var start_color: = Color(1, 1, 1)
	var end_color: = Color(0, 0, 0)
	if inverted:
		start_color = Color(0, 0, 0)
		end_color = Color(1, 1, 1)
	$Tween.interpolate_property(self, "modulate",
						start_color, end_color, 2.0,
						Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_VillagersSpawnTimer_timeout():
	spawn_villager()
	villagers_spawn_timer.wait_time = min_villagers_spawn_time + randi()%villagers_spawn_time + randf()
	villagers_spawn_timer.start()

func _on_Area2D_body_entered(body):
	if body.is_in_group("villager"):
		body.queue_free()

func _on_Road_body_entered(body):
	if body is Guardian or body is Player:
		body.on_road = true

func _on_Road_body_exited(body):
	if body is Guardian or body is Player:
		body.on_road = false

func _on_Timer_timeout():
	update_world_time()

func _on_Tween_tween_all_completed():
	match tween_type:
		"start_game":
			$GUI/Day.visible = false
			get_tree().paused = false
		"end_day":
			$GUI/Day.visible = true
			for c in get_children():
				if c.get("visible") and not c is TileMap:
					c.visible = false
			player.position = Vector2(114, 107)
			start_tween("next_day", true)
		"next_day":
			$GUI/Day.visible = false
			get_tree().paused = false
			queue_free()
			get_tree().reload_current_scene()
		"wasted":
			$GUI/PauseMenu.open_with_restart()





