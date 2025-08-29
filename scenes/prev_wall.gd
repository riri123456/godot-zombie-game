extends Node2D

func _process(delta: float) -> void:
	if is_inside_tree():
		#position = get_global_mouse_position()
		var grid_size = 8
		position = (get_global_mouse_position() / grid_size).round() * grid_size
		modulate.a = 0.5
