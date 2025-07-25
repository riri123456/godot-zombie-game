extends CanvasLayer

signal start_game

@onready var health : int = 100
@onready var score = Main.killCount

func _process(delta):
	EnemyDead()
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	$health.hide()
	$Score.hide()
	#$Score.text = 'SCORE: 0'
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "ZOMBIE GAME"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$startButton.show()
	


func _on_start_button_pressed():
	health = 100
	Main.killCount = 0
	$health.text = 'HEALTH: ' + str(health)
	$Score.text = 'SCORE: ' + str(Main.killCount) #PROBLEM
	$startButton.hide()
	$Message.hide()
	$health.show()
	$Score.show()
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
