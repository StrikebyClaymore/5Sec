extends Node2D

onready var villagers: YSort = $Villagers
onready var villagers_spawn_timer: Timer = $VillagersSpawnTimer
onready var player: Player = $Player
const  villager_tscn: PackedScene = preload("res://objects/Villager.tscn")
const guardian_tscn: PackedScene = preload("res://objects/Guardian.tscn")
var spawn_points: Array = []

var satiety: int = 0


func _ready():
	randomize()
	$Music.set_volume_db(global.volume)
	$GUI/PauseMenu/SettingsMenu/Volume/HSlider.value = global.volume
	$Music.play(global.music_time)
	spawn_points = $SpawnPoints.get_children()
	villagers_spawn_timer.start()
	$GUI.scale *= 1.5
	$Villagers/Guardian.direction = Vector2.RIGHT
	$Villagers/Guardian.patrol_direction = Vector2.RIGHT

func spawn_villager() ->  void:
	var v: Character = villager_tscn.instance()
	
	if randf() < 0.1:
		v = guardian_tscn.instance()
	
	if bool(int(round(randf()))):
		v.position.x = spawn_points[0].position.x
		v.position.y = rand_range(spawn_points[0].position.y, spawn_points[1].position.y)
		v.direction = Vector2.RIGHT
	else:
		v.position.x = spawn_points[2].position.x
		v.position.y = rand_range(spawn_points[2].position.y, spawn_points[3].position.y)
		v.direction = Vector2.LEFT
	add_villagers_colliding_exeption(v)
	villagers.add_child(v)
	pass

func eat_food(value:int) ->  void:
	satiety = min(100, satiety + value)
	update_gui()
	pass

func update_gui() -> void:
	$GUI/SatietyeProgress.value = satiety
	pass

func add_villagers_colliding_exeption(v: Character) -> void:
	player.add_collision_exception_with(v)
	v.add_collision_exception_with(player)
	for c in villagers.get_children():
		v.add_collision_exception_with(v)
		c.add_collision_exception_with(v)

func wasted() -> void:
	$GUI/Wasted.visible = true
	$GUI/Tween.interpolate_property(self, "modulate",
								Color(1, 1, 1), Color(0, 0, 0), 2.0,
								Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$GUI/Tween.start()
	get_tree().paused = true

func set_pause() -> void:
	$GUI/PauseMenu.visible = not $GUI/PauseMenu.visible
	get_tree().paused = not get_tree().paused

func _on_VillagersSpawnTimer_timeout():
	spawn_villager()
	villagers_spawn_timer.wait_time = 5 + randi()%5 + randf()
	villagers_spawn_timer.start()

func _on_Area2D_body_entered(body):
	if body.is_in_group("villager"):
		body.queue_free()

func _on_Road_body_entered(body):
	if body is Guardian:
		body.on_road = true

func _on_Road_body_exited(body):
	if body is Guardian:
		body.on_road = false

func _on_Tween_tween_all_completed():
	$GUI/PauseMenu.open_with_restart()
