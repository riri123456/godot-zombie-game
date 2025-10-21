extends CanvasLayer

signal start_game

var health : int = 100
var wood : int = 0
var wave : int = 0


func _process(_delta):
	$CollectionTime.text = 'TIME BEFORE UNDEAD ATTACK: ' + str("%0.1f" % $CollectionTimer.time_left," s")
	$WaveTimerMsg.text = 'TIME UNTIL NEXT WAVE ' + str("%0.1f" % $WaveTimer.time_left, " s")
	
func show_message(text):
	$Title.text = text
	$Title.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	$health.hide()
	$Score.hide()
	$Wood.hide()
	wave = 0
	
	await $MessageTimer.timeout

	$Title.text = "ZOMBIE GAME"
	$Title.show()
	$quit.show()
	# Make a timer and wait for finish.
	await get_tree().create_timer(1.0).timeout
	$startButton.show()
	

signal start_button
func _on_start_button_pressed():
	$quit.hide()
	start_button.emit()
	health = 100
	wood = 0
	wave += 1
	$Wood.text = 'WOOD: ' + str(wood)
	Main.kill_count = 0
	$health.text = 'HEALTH: ' + str(health)
	$Score.text = 'SCORE: ' + str(Main.kill_count) 
	$CollectionTimer.start()
	$startButton.hide()
	$Title.hide()
	$health.show()
	$Score.show()
	$Wood.show()
	$CollectionTime.show()
	await $CollectionTimer.timeout
	$CollectionTime.hide()
	start_game.emit()



func _on_message_timer_timeout():
	$Title.hide()

# signal from player scene
func Onhit():
	health -= 10
	$health.text = "HEALTH: " + str(health)



signal collectionTimer
func _on_collection_timer_timeout():
	collectionTimer.emit()

	

func _on_main_tree_chopped() -> void:
	wood += 5
	$Wood.text = 'WOOD: ' + str(wood)
	


func _on_main_wall_built() -> void:
	wood -= 3
	$Wood.text = 'WOOD: ' + str(wood)



func _on_main_enemy_dead(kill_count: int):
	$Score.text = 'SCORE: ' + str(kill_count)

signal next_wave
func _on_gem_wave_done() -> void:
	$WaveMessage.text = 'YOU HAVE NOW COMPLETED WAVE ' + str(wave)
	$WaveMessage.show()
	await get_tree().create_timer(4.0).timeout
	$WaveMessage.hide()
	$WaveTimer.start()
	$SkipWaveTimer.show()
	$WaveTimerMsg.show()
	await $WaveTimer.timeout
	$WaveTimerMsg.hide()
	next_wave.emit()
	wave += 1



func _on_gem_health_buy() -> void:
	if health < 100 and wood >= 10:
		health += 5
		$health.text = "HEALTH: " + str(health)
		wood -= 10
		$Wood.text = 'WOOD: ' + str(wood)


func _on_main_game_paused() -> void:
	$health.hide()
	$Score.hide()
	$Wood.hide()
	$Title.hide()
	$WaveMessage.hide()
	$WaveTimerMsg.hide()
	$quit.show()
	$settings.show()
	$unpause.show()


signal quit_game
func _on_quit_pressed() -> void:
	quit_game.emit()


func _on_settings_pressed() -> void:
	$ui.play()
	$quit.hide()
	$settings.hide()
	$Brightness.show()
	$Volume.show()
	$brightnessTag.show()
	$volumeTag.show()
	$music.show()
	$musicTag.show()
	
signal volume_changed
func _on_volume_value_changed(value: float):
	volume_changed.emit(value)
	
signal brightness_changed
func _on_brightness_value_changed(value: float) -> void:
	brightness_changed.emit(value)
	
signal music_changed
func _on_music_value_changed(value: float) -> void:
	music_changed.emit(value)


signal resumed
func _on_unpause_pressed() -> void:
	$ui.play()
	resumed.emit()
	$settings.hide()
	$Brightness.hide()
	$Volume.hide()
	$brightnessTag.hide()
	$volumeTag.hide()
	$unpause.hide()
	$quit.hide()
	$health.show()
	$Score.show()
	$Wood.show()
	$music.hide()
	$musicTag.hide()


func _on_skip_wave_timer_pressed() -> void:
	$WaveTimer.stop()
	$WaveTimerMsg.hide()
	next_wave.emit()
	wave += 1
	$SkipWaveTimer.hide()
	
