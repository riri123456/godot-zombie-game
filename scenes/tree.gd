extends Area2D
class_name Trees


signal tree_mined
func _on_area_entered(area: Area2D) -> void:
	if area.name == 'Sword':
		queue_free()
		tree_mined.emit()
