extends Character
class_name Player

var on_road: bool = false
var on_water_well: bool = false


func _ready():
	move_speed = 50.0
	$Camera2D.current = true

func _physics_process(delta):
	input_process()
	move_process()

#func _process(delta):
#	if direction.x > 0:
#		global_position.x = ceil(global_position.x)
#	elif direction.x < 0:
#		global_position.x = floor(global_position.x)
#	elif direction.y > 0:
#		global_position.y = ceil(global_position.y)
#	elif direction.y < 0:
#		global_position.y = floor(global_position.y)
#	force_update_transform()

func input_process() -> void:
	direction.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	direction.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	
#	if Input.is_action_just_pressed("left_click"):
#		var f = load("res://objects/Food.tscn").instance()
#		f.position = get_global_mouse_position() + Vector2(0, -8)
#		get_tree().current_scene.add_child(f)
#		f.init()

func move_process() -> void:
	if direction == Vector2.ZERO:
		stop_anim()
		return
	move_and_slide((direction * move_speed).clamped(move_speed))
	play_anim()


