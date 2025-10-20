extends Node2D
class_name Gem

var gemProgress : float = 0.0
var progressMulti : float = 10
@onready var inGem : bool
var enemyDamage : float = 5.0
@onready var enemy_gem : bool = false
@onready var midWave : bool = false
@onready var inButton : bool = false
	
signal Gemhit
func _on_area_2d_body_entered(body):
	var mousepos = get_global_mouse_position()
	if body is RigidBody2D:
		Gemhit.emit()
		gemProgress -= enemyDamage

func _on_gemhit_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		enemy_gem = false

func set_progress_bar() -> void:
	$GemProgress.value = gemProgress


func _process(delta):
	if gemProgress <= 0:
		gemProgress = 0
	$GemHealth.text = 'GEM HEALTH: ' + str(gemProgress)
	set_progress_bar()
	wave_finished()
	gemstorehub()

	

func _on_wave_done() -> void:
	gemProgress = 0.0
	set_progress_bar()

	
func _on_hud_next_wave() -> void:
	$progressIncrease.wait_time += 1
	$progressIncrease.start()
	midWave = false


signal wave_done
func wave_finished():
	if gemProgress >= 100.0:
		if !$Gemfinish.playing:
			$Gemfinish.play()
		$progressIncrease.stop()
		midWave = true
		#await get_tree().create_timer(0.5).timeout
		wave_done.emit()
		


func _on_hud_start_game():
	gemProgress = 0
	$progressIncrease.start()
	set_progress_bar()
	
	
signal mouseEnter
func _on_area_2d_mouse_entered():
	inGem = true
	#if midWave == true:
		#print('yeya')
		#$GemStore.show()
	mouseEnter.emit()

func gemstorehub():
	if inButton == true and inGem == true and midWave == true:
		$GemStore.show()
	elif inButton == false and inGem == true and midWave == true:
		$GemStore.show()
	elif inButton == true and inGem == true and midWave == true:
		$GemStore.show()
	elif inButton == false and inGem == false and midWave == true:
		$GemStore.hide()
	elif midWave == false:
		$GemStore.hide()
	
signal mouseExit
func _on_area_2d_mouse_exited():
	#if inButton == false:
		#$GemStore.hide()
	inGem = false
	mouseExit.emit()


func _on_gem_store_mouse_entered() -> void:
	inButton = true
	
func _on_gem_store_mouse_exited() -> void:
	inButton = false


signal gemProgIncr
func _on_progress_increase_timeout() -> void:
	gemProgress += progressMulti
	set_progress_bar()
	#print('the gemhealthy ' + str(gemProgress))
	gemProgIncr.emit()

signal health_buy
func _on_gem_store_pressed() -> void:
	health_buy.emit()

	
	


func _on_main_gameover() -> void:
	$progressIncrease.stop()
	$progressIncrease.wait_time = 2.0
