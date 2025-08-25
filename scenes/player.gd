extends CharacterBody2D

@onready var animations = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D

@export var SPEED = 100

@onready var previousDirection = 'Down'

@onready var Playerpost : float

@onready var weapon = $Weapon

@onready var weaponcoll = $Weapon/Sword/CollisionShape2D

var nonEnemies : Array = ['GemColl', 'Player', 'WallColl', 'StaticBody2D']


var attack: bool = false
var screenSize

func get_input():

	var input_direction = Input.get_vector("Left", "Right", "Forward", "Down")
	velocity = input_direction * SPEED
	
	
	if Input.is_action_pressed("Attack"):
		animations.play('attack' + previousDirection)
		attack = true
		weapon.show()
		$Weapon/Sword/CollisionShape2D.disabled = false
		await animations.animation_finished
		weapon.hide()
		$Weapon/Sword/CollisionShape2D.disabled = true
		attack = false

func _ready(): 
	weapon.hide()
	weaponcoll.disabled = true
	screenSize = get_viewport_rect().size


func _physics_process(delta):
	update_animation()
	get_input()
	move_and_slide()



func update_animation():
	if attack: return
	if velocity.length() == 0:
		animated_sprite.play('Idle' + previousDirection)
	else:
		if velocity.x < 0: previousDirection = 'Left'
		elif velocity.x > 0: previousDirection = 'Right'
		elif velocity.y > 0: previousDirection = 'Down'
		elif velocity.y < 0: previousDirection = 'Up'
		animated_sprite.play('Walk' + previousDirection)


func start(pos):
	position = pos
	show()
	$PlayerCollision.disabled = false
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		
signal hit

func _on_hurtbox_body_entered(body):
	#print(body.name)
	if body.name not in nonEnemies:
		hit.emit()




#signal position_changed(position)

#func _process(delta):
#	emit_signal("position_changed", self.global_position) finds player position and sends signal
		

		
		
