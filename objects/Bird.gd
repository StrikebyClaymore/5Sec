extends Character
class_name Bird

onready var wait_timer: Timer = $WaitTimer
var wait: bool = false
var roof_point: Vector2
var target_point: Vector2
var arrive_distance: float = 4.0

var min_wait_time: int = 0.05
var wait_time_divider: float = 4.0
var min_refly_time: int = 1.5


func _ready():
	randomize()
	roof_point = position
	$Idle.frame = 1 + randi()%2

func _physics_process(delta):
	if target_point == Vector2.ZERO or wait:
		return
	fly_to_target(delta)

func fly_to_target(delta:float) -> void:
	if position.distance_to(target_point) < move_speed * delta:
		target_point = Vector2.ZERO
		if position.distance_to(roof_point) < arrive_distance:
			$CollisionShape2D.call_deferred("set_disabled", false)
			stop_anim()
			wait_timer.wait_time = min_refly_time + randf() / wait_time_divider
			wait_timer.start()
		return
	direction = position.direction_to(target_point).normalized()
	move_and_collide(direction * move_speed * delta)
	play_anim()

func back_to_roof():
	$CollisionShape2D.call_deferred("set_disabled", true)
	target_point = roof_point

func play_anim() -> void:
	.play_anim()

func stop_anim() -> void:
	.stop_anim()
	$Sprite.visible = false
	$Idle.visible = true
	$Idle.frame = 1 + randi()%2

func _on_FoodDetecter_area_entered(area):
	set_target(area)

func set_target(area: Area2D) -> bool:
	if area.is_in_group("food") and target_point != roof_point and position.distance_to(area.global_position) < position.distance_to(target_point):
		wait_timer.wait_time = min_wait_time + randf() / wait_time_divider
		wait = true
		area.get_parent().birds.append(self)
		target_point = area.global_position
		wait_timer.start()
		return true
	return false

func _on_WaitTimer_timeout():
	if target_point == Vector2.ZERO:
		for c in $FoodDetecter.get_overlapping_areas():
			if set_target(c):
				return
		return
	wait = false
	$Idle.visible = false
	$Sprite.visible = true


