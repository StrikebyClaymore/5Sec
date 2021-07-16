extends Character
class_name Guardian

enum States {NONE, PATROL, FOLLOW, BACk_TO_ROAD}
var state = States.NONE
var patrol_direction: Vector2
var target: Player
var target_point: Vector2
var arrive_distance: float = 16.0
var road_arrive_distance: float = 2.0
var road_point_y: float
var on_road: bool = false


func _ready():
	patrol_direction = direction
	road_point_y = position.y
	state = States.PATROL

func _physics_process(delta):
	if state == States.FOLLOW:
		if not on_road and not target.on_road:
			direction = Vector2.ZERO
			stop_anim()
			return
		direction = position.direction_to(target.position)
		if position.distance_to(target.position) <= arrive_distance:
			direction = Vector2.ZERO
			catch_player()
	elif state == States.BACk_TO_ROAD:
		if position.distance_to(target_point) <= road_arrive_distance:
			direction = patrol_direction
			state = States.PATROL
	move_process(delta)

func move_process(delta:float) -> void:
	if direction == Vector2.ZERO:
		stop_anim()
		return
	move_and_collide((direction * move_speed).clamped(move_speed) * delta)
	play_anim()

func back_to_road() -> void:
	target_point = Vector2(position.x, road_point_y)
	direction = position.direction_to(target_point)
	state = States.BACk_TO_ROAD

func catch_player() -> void:
	get_tree().current_scene.wasted()
	state = States.NONE

func _on_PlayerDetecter_body_entered(body):
	if body is Player and on_road:
		target = body
		target_point = target.position
		state = States.FOLLOW

func _on_PlayerDetecter_body_exited(body):
	if body == target:
		target = null
		back_to_road()


