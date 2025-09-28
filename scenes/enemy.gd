extends RigidBody2D

@onready var destination = Vector2(0, 0)
@export var speed = 80
@onready var knockbackSpeed = 5
@onready var knockedback : bool = false

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	CollisionSetter()
	#print(is_connected("EnemyDead", $Hud, "EnemyDead"))
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _physics_process(delta):
	position_update(delta)
	print(knockedback)
	


func position_update(delta):
	if knockedback == false:
		position += position.direction_to(destination) * speed * delta
	elif knockedback == true:
		await get_tree().create_timer(2).timeout
		knockedback = false
	

func CollisionSetter():
	if $AnimatedSprite2D.animation == 'GhastlyEye':
		$collisionGhastlyEye.disabled = false
		$hitboxEnemy/hitboxGhastlyEye.disabled = false
	elif $AnimatedSprite2D.animation == 'BoundCadaver':
		$collisionCadaver.disabled = false
		$hitboxEnemy/hitboxCadaver.disabled = false
	else:
		$collisionCrawlers.disabled = false
		$hitboxEnemy/hitboxCrawler.disabled = false
		

func apply_knockback():
		knockedback = true
		var strength : float = 20.0
		var dir = (global_position - destination).normalized()
		linear_velocity = dir * strength
		print('hello')

		
		
#Killing enemy
func _on_hitbox_enemy_area_entered(area):
	if area.name == 'Sword':
		queue_free()
		#get_node("/root/Main").killed()
	#position -= position.direction_to(destination) * 5
	if area.name != 'Gemmouse':
		apply_knockback()
