extends RigidBody2D


func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	CollisionSetter()
	
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _physics_process(delta):
	#move_and_collide(velocity * delta)
	var destination = Vector2(0, 0)
	#var velocity = Vector2(randf_range(35, 50), 0.0)
	var speed = 120
	#mob.linear_velocity = velocity.rotated(direction)
	position += position.direction_to(destination) * speed * delta



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


#Killing enemy
func _on_hitbox_enemy_area_entered(area):
	if area.name == 'Sword':
		queue_free()
		get_node("/root/Main").killed()




	
