extends Node2D

@export var enemy_scene : PackedScene
@export var wall_scene : PackedScene
@export var preview_wall : PackedScene
@onready var health : int = 100
@onready var killCount : int = 0
@onready var gem_health : int = 100
#@onready var player : CharacterBody2D = $Player
@onready var inGem : bool = false
@onready var gameStart : bool = false
@onready var beforeGame : bool = true
@onready var tree_scene = preload('res://scenes/tree.tscn')
@onready var wood : int = 0
@onready var building_mode : bool = false
@onready var preview_wall_node : bool = false
var prevWall: Node2D = null
@onready var wave : int = 0
@onready var mob_counter : int

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
		wood = 0
		wave = 0
		$Player/PlayerCollision.set_deferred(&"disabled", true)
		get_tree().call_group(&"mobs", &"queue_free")
		get_tree().call_group(&"Obstacles", &"queue_free")
		get_tree().call_group(&"Trees", &"queue_free")
		
		
	
	
func new_game():  
	wave += 1
	print('new game wave is ' + str(wave))
	gameStart = true
	#$StartTimer.start()
	$MobTimer.start()
	$HUD.show_message("Get Ready")
	$Player.show()
	gem_health = 100

	
func tree_spawn():
	for i in range(0, 50):
		var tre = tree_scene.instantiate()
		var tree_location_x = randf_range(-505, 760)
		var tree_location_y = randf_range(-295, 330)
		tre.position = Vector2i(tree_location_x, tree_location_y)
		tre.name = 'Trees'
		add_child(tre)


func _on_mob_timer_timeout():
	mob_counter += 1
	var mob = enemy_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	add_child(mob)
	var waveMulti = (wave+2) * (wave+1)
	#print('onmob wave multi is ' + str(waveMulti))
	#print('onmob wave is ' + str(wave))
	if mob_counter == waveMulti:
		$MobTimer.stop()

	
	
func _on_player_hit():
	health -= 10
	#print(health)



func _on_gem_gemhit():
	gem_health -= 10
	#print(gem_health)
	



signal wall_built
func build():
	var mousepos = get_global_mouse_position()
	if Input.is_action_just_released("Build") and inGem == false and beforeGame == false and wood > 1 and building_mode == false:
		building_mode = true
		prevWall = preview_wall.instantiate()
		add_child(prevWall)
		print('prev')
	if Input.is_action_just_released("wall rotation") and building_mode == true:
		prevWall.rotation_degrees += 90.0
		print('rotate')
	if Input.is_action_just_released('delete_build') and building_mode == true:
		prevWall.queue_free()
		building_mode = false
	if Input.is_action_just_released("Build") and building_mode == true and inGem == false and beforeGame == false and wood > 1:
		var wall = wall_scene.instantiate()
		print(prevWall.position)
		wall.position = prevWall.position
		wall.rotation = prevWall.rotation
		prevWall.queue_free()
		wood -= 2
		wall_built.emit()
		add_child(wall)
		prevWall = preview_wall.instantiate()
		add_child(prevWall)

	
func _on_gem_mouse_exit():
	inGem = false

func _on_gem_mouse_enter():
	inGem = true


func _on_hud_start_button():
	beforeGame = false
	$Player.start($StartPosition.position)
	wood = 0
	tree_spawn()
	

signal tree_chopped
func _on_child_exiting_tree(node: Node) -> void:
	if node.is_in_group('Trees'):
		tree_chopped.emit()
		wood += 5

signal EnemyDied(killCount : int)
signal end_wave
func _on_exiting_tree(node: Node) -> void:
	var waveMulti = (wave+2) * (wave+1)
	if node.is_in_group('mobs'):
		killCount += 1
		EnemyDied.emit(killCount)

#	if killCount == waveMulti:
		
		
		
