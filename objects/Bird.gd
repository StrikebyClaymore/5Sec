extends Character
class_name Bird

onready var wait_timer: Timer = $WaitTimer
var wait: bool = false
var roof_point: Vector2
var target_point: Vector2


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
		if position.distance_to(roof_point) < 4.0:
			$CollisionShape2D.call_deferred("set_disabled", false)
			stop_anim()
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
	if area.is_in_group("food") and target_point != roof_point and position.distance_to(area.global_position) < position.distance_to(target_point):
		wait_timer.wait_time = 0.05 + randf() / 4.0
		wait = true
		area.get_parent().birds.append(self)
		target_point = area.global_position
		wait_timer.start()

func _on_WaitTimer_timeout():
	wait = false
	$Idle.visible = false
	$Sprite.visible = true


