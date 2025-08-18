extends Node2D

@export var enemy_scene : PackedScene
@onready var wall_scene = preload('res://scenes/wall.tscn')
@onready var health : int = 100
@onready var killCount : int = 0
@onready var gem_health : int = 100
@onready var player : CharacterBody2D = $Player
@onready var inGem : bool = false
@onready var gameStart : bool = false
@onready var beforeGame : bool = true
@onready var tree_scene = preload('res://scenes/tree.tscn')


func _process(delta):
	game_over()
	build()
	


func game_over():
	if health == 0 or health < 0 or gem_health <= 0:
		gameStart = false
		$MobTimer.stop()
		$HUD.show_game_over()
		$Player.hide()
		health = 100
		killCount = 0
		gem_health = 100
		$Player/PlayerCollision.set_deferred(&"disabled", true)
		get_tree().call_group(&"mobs", &"queue_free")
		get_tree().call_group(&"Obstacles", &"queue_free")
		get_tree().call_group(&"Trees", &"queue_free")
		
		
	
	
func new_game():  
	gameStart = true
	#
	#$StartTimer.start()
	$MobTimer.start()
	$HUD.show_message("Get Ready")
	$Player.show()
	gem_health = 100
	# after waves move tree stuff somewhere else
	tree_spawn()
	
	
func tree_spawn():
	for i in range(0, 10):
		var tre = tree_scene.instantiate()
		var tree_location_x = randf_range(-505, 760)
		var tree_location_y = randf_range(-295, 330)
		tre.position = Vector2i(tree_location_x, tree_location_y)
		add_child(tre)

	
func _on_mob_timer_timeout():
	var mob = enemy_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	add_child(mob)
	print(player.position)
	
	
#func _on_start_timer_timeout():
	#$MobTimer.start()
	
	
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


#func _on_player_position_changed(position):
	#var player_new_position = player.position  #finds player pos


func build():
	var mousepos = get_global_mouse_position()
	if Input.is_action_just_released("Build") and inGem == false and beforeGame == false: 
		var wall = wall_scene.instantiate()
		wall.position = mousepos
		#wall.rotation = player.rotation
		add_child(wall)
	
func _on_gem_mouse_exit():
	inGem = false

func _on_gem_mouse_enter():
	inGem = true


func _on_hud_start_button():
	beforeGame = false
	$Player.start($StartPosition.position)
