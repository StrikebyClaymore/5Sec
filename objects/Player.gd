extends Character
class_name Player


func _ready():
	move_speed = 50.0

func _physics_process(delta):
	input_process()
	move_process()
	pass

func input_process() -> void:
	direction.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	direction.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	
	if Input.is_action_just_pressed("left_click"):
		var f = load("res://objects/Food.tscn").instance()
		f.position = get_global_mouse_position() + Vector2(0, -8)
		get_tree().current_scene.add_child(f)
		f.init()

func move_process() -> void:
	if direction == Vector2.ZERO:
		stop_anim()
		return
	move_and_slide((direction * move_speed).clamped(move_speed))
	play_anim()


