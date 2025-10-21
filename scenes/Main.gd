extends Node2D

@export var enemy_scene : PackedScene
@export var wall_scene : PackedScene
@export var preview_wall : PackedScene
var health : int = 100
var kill_count : int = 0
var gem_health : int = 100
var mouse_in_gem : bool = false
var game_start : bool = false
var before_game : bool = true
@onready var tree_scene = preload('res://scenes/tree.tscn')
var wood : int = 0
var building_mode : bool = false
var preview_wall_instance: Node2D = null
var wave : int = 0
var mob_counter : int
var wave_multiplier : int = 5
var game_paused_bool : bool = false


func _process(_delta: float) -> void:
	game_over()
	pause_game()

	
signal game_paused
func pause_game():
	if game_start and Input.is_action_just_released('ui_cancel') and !game_paused_bool:
		print('hello')
		get_tree().paused = true
		modulate.a = 0.2
		game_paused.emit()
		game_paused_bool = true

func _on_hud_resumed() -> void:
	get_tree().paused = false
	modulate.a = 1
	game_paused_bool = false
	
		
signal game_over_signal
func game_over():
	if health <= 0:
		$MobTimer.wait_time = 3.0
		game_over_signal.emit()
		game_start = false
		$MobTimer.stop()
		$HUD.show_game_over()
		$Gem.hide()
		$Player.hide()
		$PostMusic.stop()
		health = 100
		kill_count = 0
		gem_health = 100
		wood = 0
		wave = 0
		$Player/PlayerCollision.set_deferred(&"disabled", true)
		get_tree().call_group(&"mobs", &"queue_free")
		get_tree().call_group(&"Obstacles", &"queue_free")
		get_tree().call_group(&"Trees", &"queue_free")
		
		
func new_game():  
	wave += 1
	print(wave)
	game_start = true
	print(game_start)
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
			tree.position = Vector2(tree_location_x, tree_location_y)
			tree.name = 'Trees'
			add_child(tree)


func _on_mob_timer_timeout():
	mob_counter += 1
	var mob = enemy_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	mob.speed += wave*2 + 4
	add_child(mob)
	wave_multiplier = int(5 * pow(2, wave - 1))
		
		
func _on_player_hit():
	health -= 10

func _on_gem_gemhit():
	gem_health -= 5
	
func start_build():
	building_mode = true
	preview_wall_instance = preview_wall.instantiate()
	add_child(preview_wall_instance)
	preview_wall_instance.global_position = get_global_mouse_position()
	
func confirm_build():
	var wall = wall_scene.instantiate()
	wall.global_position = preview_wall_instance.global_position
	wall.rotation = preview_wall_instance.rotation
	add_child(wall)
	wood -= 3

signal wall_built
func _input(event: InputEvent) -> void:
	if event.is_action_released("Build"):
		if !building_mode and !mouse_in_gem and !before_game and wood > 1:
			start_build()
		elif building_mode and !mouse_in_gem and !before_game and wood > 1:
			confirm_build()
			wall_built.emit()
	elif event.is_action_pressed('wall rotation') and building_mode == true:
		preview_wall_instance.rotation_degrees += 90.0
	elif event.is_action_pressed('delete_build') and building_mode == true:
		preview_wall_instance.queue_free()
		building_mode = false
		
		
		
func _on_gem_mouse_exit():
	mouse_in_gem = false

func _on_gem_mouse_enter():
	mouse_in_gem = true


func _on_hud_start_button():
	before_game = false
	$Player.start($StartPosition.position)
	wood = 0
	tree_spawn()
	

signal tree_chopped
func _on_child_exiting_tree(node: Node) -> void:
	if node.is_in_group('Trees'):
		tree_chopped.emit()
		tree_count -= 1
		wood += 5

signal enemy_died(killCount : int)
func _on_exiting_tree(node: Node) -> void:
	wave_multiplier = int(5 * pow(2, wave - 1))
	if node.is_in_group('mobs'):
		kill_count += 1
		enemy_died.emit(kill_count)


func _on_gem_health_buy() -> void:
	if health < 99 and wood >= 10:
		health += 5
		wood -= 10
		$GemBuy.play()


func _on_hud_quit_game() -> void:
	get_tree().quit()


func _on_hud_volume_changed(value: float) -> void:
	var volume = AudioServer.get_bus_index('Master')
	AudioServer.set_bus_volume_db(volume, linear_to_db(value))


func _on_hud_brightness_changed(value: float) -> void:
	$".".modulate = Color(value, value, value, value)


func _on_hud_music_changed(value: float) -> void:
	var music = AudioServer.get_bus_index('Music')
	AudioServer.set_bus_volume_db(music, linear_to_db(value))
