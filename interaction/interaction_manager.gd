extends Node2D

@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var label:Label=$Label
var can_interact:bool=true
var active_areas:Array[InteractionArea] = []
var base_text:String = "[E] to"
func register_interaction(area:InteractionArea):
	print("registered")
	active_areas.push_back(area)

func unregister(area:InteractionArea):
	var index= active_areas.find(area)
	if index !=-1:
		active_areas.remove_at(index)
	
func _process(delta: float) -> void:
	if active_areas.size()>0 and can_interact:
		active_areas.sort_custom(Callable(self,"sort_by_distance_to_player"))
		label.text = base_text+active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y +=80
		label.global_position.x += label.size.x/2 + 180

		label.show()
	else:
		label.hide()	
func sort_by_distance_to_player(area1:InteractionArea,area2:InteractionArea):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.direction_to(area2.global_position)
	return area1_to_player<area2_to_player
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("INTEACT") and can_interact:
		if active_areas.size()>0:
			can_interact= false
			label.hide()
			await active_areas[0].interact.call()
			can_interact = true
			
