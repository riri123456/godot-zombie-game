extends Node2D

@onready var wall_health : int = 2

func _ready() -> void:
	# Force correct transform immediately
	global_position = global_position
	rotation = rotation


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('mobs'):
		#print(body.name)
		wall_health -= 1
		#print(wall_health)
	if wall_health == 0:
		queue_free()
		

	
