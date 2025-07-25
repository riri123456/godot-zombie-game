extends Node2D
class_name Gem

var gemHealth = 100


signal Gemhit
func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		Gemhit.emit()
		gemHealth -= 10

func _process(delta):
	$GemHealth.text = 'GEM HEALTH: ' + str(gemHealth)



func _on_hud_start_game():
	gemHealth = 100
