extends Control

var messages: Dictionary = {
	1: "",
	2: ("По приказу Лорда на улицы города будут выпущены птицы, дабы поедать " +
		"упавшую на землю еду, тем самым избавляясь от лишнего мусора и гнили"),
	3: ("По приказу Лорда с сегодняшнего дня стражники будут прогонять из города нищих, " +
		"которые мешают движению на дорогах. Побираться разрешается только у колодца, " +
		"не мешая при этом жизни города"),
	4:("Лорд пригласил в город пришельцев, чтобы они забирали горожан для исследований"),
	5:("Поздравляю, вы спрапились со всеми трудностями и набрали достаточно еды " +
		"для того чтобы ещё долго жить без попрошайничества")
}


func show_message(day:int) -> void:
	if global.continue_game:
		get_tree().paused = false
		return
	if global.world_day > messages.size():
		get_tree().paused = false
		return
	if global.first_play and day == 1:
		global.first_play = false
	elif not global.first_play and day == 1:
		get_tree().paused = false
		return
	if day != 1:
		$Label.text = messages[day]
	visible = true
	#get_tree().paused = true

func _on_Close_pressed():
	visible = false
	if get_parent().get_node("PauseMenu").visible:
		return
	get_tree().paused = false
	if global.world_day == 5 and not global.continue_game:
		get_tree().change_scene_to(global.end_scene)
