extends Node2D
class_name Gem

var gemProgress : float = 0.0
var progressMulti : float = 10
@onready var inGem : bool
var enemyDamage : float = 5.0
@onready var enemy_gem : bool = false
	
signal Gemhit
func _on_area_2d_body_entered(body):
	var mousepos = get_global_mouse_position()
	if body is RigidBody2D:
		Gemhit.emit()
		gemProgress -= enemyDamage

func _on_gemhit_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		enemy_gem = false

#NOT WORKING JUST DO KNOCKBACK

			


func _process(delta):
	if gemProgress <= 0:
		gemProgress = 0
	$GemHealth.text = 'GEM HEALTH: ' + str(gemProgress)
	wave_finished()
	



func _on_wave_done() -> void:
	gemProgress = 0.0
	
func _on_hud_next_wave() -> void:
	$progressIncrease.wait_time += 1
	$progressIncrease.start()


signal wave_done
func wave_finished():
	if gemProgress >= 100.0:
		$progressIncrease.stop()
		#await get_tree().create_timer(0.5).timeout
		wave_done.emit()
		


func _on_hud_start_game():
	gemProgress = 0
	$progressIncrease.start()
	
	
signal mouseEnter
func _on_area_2d_mouse_entered():
	inGem = true
	mouseEnter.emit()

# Checking if mouse inside gem V^
signal mouseExit
func _on_area_2d_mouse_exited():
	inGem = false
	mouseExit.emit()


signal gemProgIncr
func _on_progress_increase_timeout() -> void:
	gemProgress += progressMulti
	#print('the gemhealthy ' + str(gemProgress))
	gemProgIncr.emit()
