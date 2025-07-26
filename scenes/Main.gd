extends Node2D

@export var enemy_scene : PackedScene
@onready var wall_scene = preload('res://scenes/wall.tscn')
@onready var health : int = 100
#@onready var PlayerColl = $Player/PlayerCollision
@onready var killCount : int = 0
@onready var gem_health : int = 100
@onready var player : CharacterBody2D = $Player
#@onready var spawnpoint = $Player.global_position

func _ready():
	pass


func _process(delta):
	game_over()
	build()
	#_on_player_position_changed(position)

	



func game_over():
	if health == 0 or health < 0 or gem_health <= 0:
		$MobTimer.stop()
		$HUD.show_game_over()
		$Player.hide()
		health = 100
		killCount = 0
		gem_health = 100
		$Player/PlayerCollision.set_deferred(&"disabled", true)
		get_tree().call_group(&"mobs", &"queue_free")
		#wall_scene.queue_free()
		
	
	
func new_game():  
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$Player.show()
	gem_health = 100
	
	
	
func _on_mob_timer_timeout():
	var mob = enemy_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	add_child(mob)
	
	
func _on_start_timer_timeout():
	$MobTimer.start()
	
	
func _on_player_hit():
	health -= 10
	#print(health)

signal EnemyDead
func killed():
	killCount += 1
	EnemyDead.emit()
	#print(killCount)



func _on_gem_gemhit():
	gem_health -= 10
	print(gem_health)


func _on_player_position_changed(position):
	var wallpos = Vector2(20, 0)
	var player_new_position = player.position
	print(player_new_position)
	
	
func build():
	if Input.is_action_just_released("Build"):
		var mousepos = get_global_mouse_position()
		#print(mousepos)
		var wall = wall_scene.instantiate()
		wall.position = mousepos
		print(wall.position)
		#wall.rotation = player.rotation
		add_child(wall)
