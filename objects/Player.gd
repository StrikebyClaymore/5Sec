extends Character
class_name Player

var on_road: bool = false
var on_water_well: bool = false


func _ready():
	move_speed = 160.0
	$Camera2D.current = true

func _physics_process(delta):
	input_process()
	move_process(delta)

func input_process() -> void:
	direction.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	direction.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	
#	if Input.is_action_just_pressed("left_click"):
#		var f = load("res://objects/Food.tscn").instance()
#		f.position = get_global_mouse_position() + Vector2(0, -8)
#		get_tree().current_scene.add_child(f)
#		f.init()

func move_process(delta:float) -> void:
	if direction == Vector2.ZERO:
		stop_anim()
		return
	move_and_slide((direction * move_speed).clamped(move_speed))
	play_anim()


