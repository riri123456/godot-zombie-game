extends CanvasLayer

signal start_game

@onready var health : int = 100
@onready var wood : int = 0
@onready var wave : int = 0
@onready var waveMulti : int = 5


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
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Title.text = "ZOMBIE GAME"
	$Title.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$startButton.show()
	

signal start_button
func _on_start_button_pressed():
	start_button.emit()
	health = 100
	wood = 0
	wave += 1
	$Wood.text = 'WOOD: ' + str(wood)
	Main.killCount = 0
	$health.text = 'HEALTH: ' + str(health)
	$Score.text = 'SCORE: ' + str(Main.killCount) 
	$CollectionTimer.start()
	#var collectionTime = $CollectionTimer.time_left
	#$CollectionTime.text = 'TIME BEFORE UNDEAD ATTACK: ' + str($CollectionTimer.time_left)
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
	wood -= 2
	$Wood.text = 'WOOD: ' + str(wood)



func _on_main_enemy_dead(killCount: int):
	$Score.text = 'SCORE: ' + str(killCount)

signal next_wave
func _on_gem_wave_done() -> void:
	$WaveMessage.text = 'YOU HAVE NOW COMPLETED WAVE ' + str(wave)
	$WaveMessage.show()
	await get_tree().create_timer(4.0).timeout
	$WaveMessage.hide()
	$WaveTimer.start()
	$WaveTimerMsg.show()
	await $WaveTimer.timeout
	$WaveTimerMsg.hide()
	next_wave.emit()
	wave += 1



func _on_gem_health_buy() -> void:
	if health <= 100 and wood >= 5:
		health += 5
		$health.text = "HEALTH: " + str(health)
		wood -= 5
		$Wood.text = 'WOOD: ' + str(wood)


func _on_main_game_paused() -> void:
	#get_tree().paused = true
	$health.hide()
	$Score.hide()
	$Wood.hide()
	$Title.hide()
	$WaveMessage.hide()
	$WaveTimerMsg.hide()
	$quit.show()
	$settings.show()
	
	

signal quit_game
func _on_quit_pressed() -> void:
	quit_game.emit()


func _on_settings_pressed() -> void:
	$quit.hide()
	$settings.hide()
	$Brightness.show()

signal volume_changed
func _on_volume_value_changed(value: float):
	pass
	#volume_changed.emit(value: float)
