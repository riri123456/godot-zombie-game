extends Area2D
class_name Trees


func _on_area_entered(area: Area2D) -> void:
	if area.name == 'Sword':
		queue_free()
	if area.is_in_group('Trees'):
		queue_free()
