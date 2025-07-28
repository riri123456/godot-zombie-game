extends Node2D
class_name Gem

var gemHealth = 100
@onready var inGem : bool
	
signal Gemhit

func _on_area_2d_body_entered(body):
	var mousepos = get_global_mouse_position()
	if body is RigidBody2D:
		Gemhit.emit()
		gemHealth -= 10




func _process(delta):
	$GemHealth.text = 'GEM HEALTH: ' + str(gemHealth)



func _on_hud_start_game():
	gemHealth = 100
	
signal mouseEnter
func _on_area_2d_mouse_entered():
	inGem = true
	mouseEnter.emit()

									# Checking if mouse inside gem 
signal mouseExit
func _on_area_2d_mouse_exited():
	inGem = false
	mouseExit.emit()
