extends Sprite2D

@onready var interaction_area = $InteractionArea
func _ready() -> void:
	interaction_area.interact = Callable(self,"printy")
func printy():
	print("door open")	
	
