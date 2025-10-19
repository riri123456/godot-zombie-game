extends RigidBody2D
class_name Enemy

@onready var destination = Vector2(0, 0)
@export var speed = 80
@export var knockback_strength: float = 300.0
@export var velocity_threshold: float = 10.0

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	CollisionSetter()
	linear_damp = 5.0
	#print(is_connected("EnemyDead", $Hud, "EnemyDead"))
	
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

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
	if area.name != 'Gemmouse' and area.name != 'hitboxEnemy' and area.name != 'wallColl':
		#print(area.name)
		apply_knockback(area.global_position)
		if !$hit.playing:
			$hit.play()
		

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
		if state.linear_velocity.length() > velocity_threshold:
			return
		
		position += position.direction_to(destination) * speed * state.step
		
func apply_knockback(from_pos: Vector2) -> void:
	var dir = (global_position - from_pos).normalized()
	apply_central_impulse(dir * knockback_strength)
