extends Node2D

@export var enemy_scene : PackedScene
@export var wall_scene : PackedScene
@export var preview_wall : PackedScene
@onready var health : int = 100
@onready var killCount : int = 0
@onready var gem_health : int = 100
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
@onready var waveMulti : int = 5
@onready var gamePaused : bool = false


func _process(delta: float) -> void:
	game_over()
	pause_game()

	
signal game_paused
signal game_unpaused
func pause_game():
	if gameStart == true and Input.is_action_just_released('ui_cancel') and gamePaused == false:
		get_tree().paused = true
		modulate.a = 0.2
		game_paused.emit()

func _on_hud_resumed() -> void:
	get_tree().paused = false
	modulate.a = 1
	
		
signal gameover
func game_over():
	if health == 0 or health < 0:
		$MobTimer.wait_time = 2.5
		gameover.emit()
		gameStart = false
		$MobTimer.stop()
		$HUD.show_game_over()
		$Gem.hide()
		$Player.hide()
		$PostMusic.stop()
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
	gameStart = true
	$Premusic.stop()
	$PostMusic.play()
	$MobTimer.start()
	$HUD.show_message("Get Ready")
	$Player.show()
	$Gem.show()

func wave_done():
	wave += 1
	get_tree().call_group(&"mobs", &"queue_free")
	$MobTimer.stop()
	tree_spawn()
	
func next_wave():
	if $MobTimer.wait_time >= 0.5:
		$MobTimer.wait_time -= 0.2
	$MobTimer.start()

	

var tree_count : int
func tree_spawn():
	var higher = randi_range(4, 14)
	if tree_count <= 35:
		for i in range(0, higher):
			tree_count += 1
			var tree = tree_scene.instantiate()
			var tree_location_x = randf_range(-505, 760)
			var tree_location_y = randf_range(-295, 330)
			tree.position = Vector2i(tree_location_x, tree_location_y)
			tree.name = 'Trees'
			add_child(tree)


func _on_mob_timer_timeout():
	mob_counter += 1
	var mob = enemy_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	mob.speed += wave*2 + 4
	#print(mob.speed)
	add_child(mob)
	waveMulti = int(5 * pow(2, wave - 1))
		
		
func _on_player_hit():
	health -= 10

func _on_gem_gemhit():
	gem_health -= 5
	
func start_build():
	building_mode = true
	prevWall = preview_wall.instantiate()
	add_child(prevWall)
	prevWall.global_position = get_global_mouse_position()
	
func confirm_build():
	var wall = wall_scene.instantiate()
	wall.global_position = prevWall.global_position
	wall.rotation = prevWall.rotation
	add_child(wall)
	wood -= 2

signal wall_built
func _input(event: InputEvent) -> void:
	if event.is_action_released("Build"):
		if not building_mode and not inGem and not beforeGame and wood > 1:
			start_build()
		elif building_mode and not inGem and not beforeGame and wood > 1:
			confirm_build()
			wall_built.emit()
	elif event.is_action_pressed('wall rotation') and building_mode == true:
		prevWall.rotation_degrees += 90.0
	elif event.is_action_pressed('delete_build') and building_mode == true:
		prevWall.queue_free()
		building_mode = false
		
		
		
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
		tree_count -= 1
		wood += 5

signal EnemyDied(killCount : int)
signal end_wave
func _on_exiting_tree(node: Node) -> void:
	waveMulti = int(5 * pow(2, wave - 1))
	if node.is_in_group('mobs'):
		killCount += 1
		EnemyDied.emit(killCount)


func _on_gem_health_buy() -> void:
	if health < 99 and wood >= 5:
		health += 5
		wood -= 10
		$GemBuy.play()


func _on_hud_quit_game() -> void:
	get_tree().quit()


func _on_hud_volume_changed(value: float) -> void:
	var Volume = AudioServer.get_bus_index('Master')
	AudioServer.set_bus_volume_db(Volume, linear_to_db(value))


func _on_hud_brightness_changed(value: float) -> void:
	$".".modulate = Color(value, value, value, value)


func _on_hud_music_changed(value: float) -> void:
	var music = AudioServer.get_bus_index('Music')
	AudioServer.set_bus_volume_db(music, linear_to_db(value))
