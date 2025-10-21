extends Node2D

var wall_health : int = 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('mobs'):
		wall_health -= 1
	if wall_health == 0:
		queue_free()
		
