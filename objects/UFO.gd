extends Character
class_name UFO

enum States { NONE, FREE_FLY, FOLLOW, CATCH }
var state = States.NONE
var free_fly_direction: Vector2
var target: Character
var can_catch: bool = true
var road_point_y: float


func _ready():
	move_speed = 45
	free_fly_direction = direction
	road_point_y = position.y
	state = States.FREE_FLY

func _physics_process(delta):
	if state == States.FOLLOW:
		direction = $MobsDetecter.global_position.direction_to(target.position)
		if $MobsDetecter.global_position.distance_to(target.position) <= move_speed * delta:
			catch_mob()
	move_process(delta)

func move_process(delta:float) -> void:
	if direction == Vector2.ZERO:
		return
	move_and_collide((direction * move_speed).clamped(move_speed) * delta)

func catch_mob() -> void:
	state = States.CATCH
	direction = Vector2.ZERO
	can_catch = false
	target.set_physics_process(false)
	target.stop_anim()
	animator.play("catch_mob")

func transport_mob_to_ufo() -> void:
	target.locked = true
	target.set_front()
	target.animator.play("transport_to_ufo")

func transport_mob_ended() -> void:
	if target is Player:
		get_tree().current_scene.wasted()
		return
	direction = free_fly_direction
	state = States.FREE_FLY
	target.queue_free()
	target = null
	animator.play("blink_back_to_road")
	$CatchColdownTimer.start()

func blink_to_road() -> void:
	position.y = road_point_y
	direction = free_fly_direction
	state = States.FREE_FLY

func set_target(body: Character) -> bool:
	if can_catch and not target and body is Character and not body.locked:
		target = body
		state = States.FOLLOW
		target.locked = true
	return false

func _on_MobsDetecter_body_entered(body):
	set_target(body)

func _on_CatchColdownTimer_timeout():
	can_catch = true
	if not target:
		for body in $MobsDetecter.get_overlapping_bodies():
			if position.direction_to(body.position).x == free_fly_direction.x:
				if set_target(body):
					return

func _on_MobsDetecter_body_exited(body):
	if body == target:
		state = States.NONE
		target = null
		direction = Vector2.ZERO
		animator.play("blink_back_to_road")
