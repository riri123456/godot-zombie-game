extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D
var SPEED = 100
var previous_direction = 'Down'
@onready var weapon = $Weapon
@onready var weapon_collision_shape = $Weapon/Sword/CollisionShape2D
var non_enemies : Array = ['GemColl', 'Player', 'WallColl', 'StaticBody2D', 'Worldborder']
var attack: bool = false
var screen_size


func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Forward", "Down")
	velocity = input_direction * SPEED

	
	if Input.is_action_pressed("Attack"):
		animations.play('attack' + previous_direction)
		if !$attack.playing:
			$attack.play()
		attack = true
		weapon.show()
		$Weapon/Sword/CollisionShape2D.disabled = false
		await animations.animation_finished
		weapon.hide()
		$Weapon/Sword/CollisionShape2D.disabled = true
		attack = false

func _ready(): 
	weapon.hide()
	weapon_collision_shape.disabled = true
	screen_size = get_viewport_rect().size


func _physics_process(_delta):
	update_animation()
	get_input()
	move_and_slide()



func update_animation():
	if attack: return
	if velocity.length() == 0:
		animated_sprite.play('Idle' + previous_direction)
	else:
		if velocity.x < 0: previous_direction = 'Left'
		elif velocity.x > 0: previous_direction = 'Right'
		elif velocity.y > 0: previous_direction = 'Down'
		elif velocity.y < 0: previous_direction = 'Up'
		animated_sprite.play('Walk' + previous_direction)
		if !$walking.playing:
			$walking.play()
		


func start(pos):
	position = pos
	show()
	$PlayerCollision.disabled = false
	

signal hit
func _on_hurtbox_body_entered(body):
	#print(body.name)
	if body.name not in non_enemies:
		hit.emit()
