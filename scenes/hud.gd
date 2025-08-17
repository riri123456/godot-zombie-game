extends CanvasLayer

signal start_game

@onready var health : int = 100

func _process(_delta):
	EnemyDead()
	$CollectionTime.text = 'TIME BEFORE UNDEAD ATTACK: ' + str("%0.1f" % $CollectionTimer.time_left," s")
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	$health.hide()
	$Score.hide()
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "ZOMBIE GAME"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$startButton.show()
	

signal start_button
func _on_start_button_pressed():
	start_button.emit()
	health = 100
	Main.killCount = 0
	$health.text = 'HEALTH: ' + str(health)
	$Score.text = 'SCORE: ' + str(Main.killCount) 
	$CollectionTimer.start()
	#var collectionTime = $CollectionTimer.time_left
	#$CollectionTime.text = 'TIME BEFORE UNDEAD ATTACK: ' + str($CollectionTimer.time_left)
	$startButton.hide()
	$Message.hide()
	$health.show()
	$Score.show()
	$CollectionTime.show()
	await $CollectionTimer.timeout
	$CollectionTime.hide()
	start_game.emit()



func _on_message_timer_timeout():
	$Message.hide()

# signal from player scene
func Onhit():
	health -= 10
	$health.text = "HEALTH: " + str(health)

func EnemyDead():
	var score = Main.killCount
	$Score.text = 'SCORE: ' + str(score)

signal collectionTimer
func _on_collection_timer_timeout():
	collectionTimer.emit()
	
