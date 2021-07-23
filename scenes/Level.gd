extends Node2D

onready var villagers: YSort = $YSort/Mobs
onready var villagers_spawn_timer: Timer = $VillagersSpawnTimer
onready var player: Player = $YSort/Player
onready var world_time_timer: Timer = $GUI/Time/Timer
onready var food: Node2D = $YSort/Food
onready var dialog_system: Control = $GUI/DialogSystem
onready var music: AudioStreamPlayer = $Music
onready var volume_slider: HSlider = $GUI/PauseMenu/SettingsMenu/Volume/HSlider
const  villager_tscn: PackedScene = preload("res://objects/Villager.tscn")
const guardian_tscn: PackedScene = preload("res://objects/Guardian.tscn")
const ufo_tscn: PackedScene = preload("res://objects/UFO.tscn")
var spawn_points: Array = []
var satiety: int = 0
var world_time: Dictionary = { hour = 8, minut = 0 }
var start_day_time: String = "8:00"
var end_day_time: int = 21
var min_villagers_spawn_time: int = 1
var villagers_spawn_time: int = 3
var tween_type: String
var spawn_counter: int = 0


func _ready():
	randomize()
	music.set_volume_db(global.volume)
	volume_slider.value = global.volume
	music.play(global.music_time)
	$GUI/Time/Label.text = start_day_time
	spawn_points = $SpawnPoints.get_children()
	villagers_spawn_timer.start()
	world_time_timer.start()
	$GUI.scale *= 1.5
	get_tree().paused = true
	
	if global.world_day < 2:
		for c in $YSort/Birds.get_children():
			c.set_physics_process(false)
		$YSort/Birds.visible = false
	#$YSort/Mobs/Guardian.direction = Vector2.LEFT
	#$YSort/Mobs/Guardian.patrol_direction = Vector2.LEFT
	start_game()

func spawn_villager() ->  void:
	var v: Character = villager_tscn.instance()
	
	if global.world_day >= 3 and global.world_day != 4 and (randf() < 0.1 or (spawn_counter == 8 and global.world_day == 3)):
		v = guardian_tscn.instance()
		spawn_counter = 0
	
	elif global.world_day >= 4 and randf() < 0.05 or (global.world_day >= 4 and spawn_counter == 10):
		v = ufo_tscn.instance()
		spawn_counter = 0
	
	var side: bool = global.bool_rand()
	if side:
		v.position.x = spawn_points[0].position.x
		v.position.y = rand_range(spawn_points[0].position.y, spawn_points[1].position.y)
		v.direction = Vector2.RIGHT
	else:
		v.position.x = spawn_points[2].position.x
		v.position.y = rand_range(spawn_points[2].position.y, spawn_points[3].position.y)
		v.direction = Vector2.LEFT
	
	if v is UFO:
		if side:
			v.position.x += 32
		else:
			v.position.x -= 32
		v.position.y -= 52
	
	add_villagers_colliding_exeption(v)
	villagers.add_child(v)
	spawn_counter += 1

#func spawn_ufo():
#	var v: UFO = ufo_tscn.instance()
#	v.position.x = spawn_points[0].position.x
#	v.position.y = rand_range(spawn_points[0].position.y, spawn_points[1].position.y)
#	v.direction = Vector2.RIGHT
#	v.position.x += 32
#	v.position.y -= 52
#	add_villagers_colliding_exeption(v)
#	villagers.add_child(v)

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
	if dialog_system.visible or (tween_type == "start_game" and $Tween.is_active()):
		return
	get_tree().paused = not get_tree().paused

func update_world_time() -> void:
	world_time.minut += 10
	if world_time.minut >= 60:
		world_time.minut = 0
		world_time.hour += 1
	$GUI/Time/Label.text = str(world_time.hour) + ":" + str(world_time.minut)
	if world_time.minut == 0:
		$GUI/Time/Label.text += str(0)
	
	if world_time.hour > 15:
		$Shadow/Tween.interpolate_property($Shadow, "color",
							$Shadow.color, $Shadow.color - Color(0.025, 0.025, 0.025, 0), 1.5,
							Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Shadow/Tween.start()
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
	global.music_time = music.get_playback_position()
	get_tree().paused = true

func start_game() -> void:
	if global.world_day == 1:
		$GUI/Day.visible = true
		start_tween("start_game", true)
	else:
		dialog_system.show_message(global.world_day)

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
	if world_time.hour >= 19:
		for c in villagers.get_children():
			if c.has_method("set_end_day"):
				c.set_end_day()
		return
	if world_time.hour < 18:
		spawn_villager()
		villagers_spawn_timer.wait_time = min_villagers_spawn_time + randi()%villagers_spawn_time + randf()
	elif world_time.hour == 18:
		for c in villagers.get_children():
			if c.has_method("stop_wait"):
				c.stop_wait()
	villagers_spawn_timer.start()

func _on_Area2D_body_entered(body):
	if body.is_in_group("mob") and not body is Player:
		body.queue_free()
		if world_time.hour >= 18 and villagers.get_child_count() == 1:
			wasted()

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
			dialog_system.show_message(global.world_day)
			#get_tree().paused = false
		"end_day":
			$GUI/Day.visible = true
			for c in get_children():
				if c.get("visible") and not c is TileMap:
					c.visible = false
			player.position = $PlayerSpawnPoint.position
			start_tween("next_day", true)
		"next_day":
			$GUI/Day.visible = false
			get_tree().paused = false
			queue_free()
			get_tree().reload_current_scene()
		"wasted":
			$GUI/PauseMenu.open_with_restart()

func _on_WaterWell_body_entered(body):
	if body is Player:
		body.on_water_well = true

func _on_WaterWell_body_exited(body):
	if not body is Player:
		return
	body.on_water_well = false
	for guard in get_tree().get_nodes_in_group("guardian"):
		if guard.target == body:
			guard.play_halt()
