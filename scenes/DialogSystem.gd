extends Control

var messages: Dictionary = {
	1: "",
	2: ("По приказу Лорда в город будут выпущены птицы, чтобы поедать " +
		"упавшую на землю еду, тем самым избавляясь от лишнего мусора и гнили"),
	3: ("По приказу Лорда с сегодняшнего стражники будут прогонять из города нищих, " +
		"которые мешают движению на дорогах. Побираться разрешается только у колодца, " +
		"не мешая при этом жизни города")
}


func show_message(day:int) -> void:
	if day != 1:
		$Label.text = messages[day]
	visible = true
	#get_tree().paused = true
	pass

func _on_Close_pressed():
	visible = false
	if get_parent().get_node("PauseMenu").visible:
		return
	get_tree().paused = false
