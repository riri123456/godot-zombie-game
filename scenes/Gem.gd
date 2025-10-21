extends Node2D
class_name Gem

var gem_progress : float = 0.0
var progress_multiplier : float = 10.0
var mouse_in_gem : bool
var enemy_damage : float = 5.0
var enemy_gem : bool = false
var mid_wave : bool = false
var mouse_in_button : bool = false
	
signal Gemhit
func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		Gemhit.emit()
		gem_progress -= enemy_damage

func _on_gemhit_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		enemy_gem = false

func set_progress_bar() -> void:
	$GemProgress.value = gem_progress


func _process(_delta):
	if gem_progress <= 0:
		gem_progress = 0
	$GemHealth.text = 'GEM HEALTH: ' + str(gem_progress)
	set_progress_bar()
	wave_finished()
	gem_store_hub()

	

func _on_wave_done() -> void:
	gem_progress = 0.0
	set_progress_bar()

	
func _on_hud_next_wave() -> void:
	$progressIncrease.wait_time += 1
	$progressIncrease.start()
	mid_wave = false


signal wave_done
func wave_finished():
	if gem_progress >= 100.0:
		if !$Gemfinish.playing:
			$Gemfinish.play()
		$progressIncrease.stop()
		mid_wave = true
		wave_done.emit()
		


func _on_hud_start_game():
	gem_progress = 0
	$progressIncrease.start()
	set_progress_bar()
	
	
signal mouseEnter
func _on_area_2d_mouse_entered():
	mouse_in_gem = true
	mouseEnter.emit()

func gem_store_hub():
	if mouse_in_button and mouse_in_gem and mid_wave:
		$GemStore.show()
	elif !mouse_in_button and mouse_in_gem and mid_wave:
		$GemStore.show()
	elif !mouse_in_button and !mouse_in_gem and mid_wave:
		$GemStore.hide()
	elif !mid_wave:
		$GemStore.hide()
	
signal mouseExit
func _on_area_2d_mouse_exited():
	mouse_in_gem = false
	mouseExit.emit()


func _on_gem_store_mouse_entered() -> void:
	mouse_in_button = true
	
func _on_gem_store_mouse_exited() -> void:
	mouse_in_button = false


func _on_progress_increase_timeout() -> void:
	gem_progress += progress_multiplier
	set_progress_bar()

signal health_buy
func _on_gem_store_pressed() -> void:
	health_buy.emit()

func _on_main_gameover() -> void:
	$progressIncrease.stop()
	$progressIncrease.wait_time = 2.0
