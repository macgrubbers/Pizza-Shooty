extends weapon_3d

@onready var reload_timer: Timer = Timer.new()
@onready var bullet_scene = preload("res://3D Test/Bullet3D.tscn")

var max_ammo: int = 8
var current_ammo: int = max_ammo
var bullets_per_shot: int = 1

var time_to_reload: int = 0.5
var can_fire: bool = true

func _ready():
	# Timer setup
	reload_timer.set_one_shot(true)
	reload_timer.connect("timeout", _on_reload_timer_timeout)
	reload_timer.set_wait_time(time_to_reload)
	add_child(reload_timer)


func _physics_process(delta):
	if Input.is_action_just_released("LMB"):
		can_fire = true
		
	if Input.is_action_just_pressed("r") and reload_timer.is_stopped():
		reload_timer.start()
		print("Reloading...")

func _on_reload_timer_timeout():
	current_ammo = max_ammo
	reload_timer.stop()
	print("Reloaded!!!")


func shoot():
	if (current_ammo != 0 and can_fire and current_ammo > 0):
		if (!reload_timer.is_stopped()):
			reload_timer.stop()
		# Shoot bullets per shot
		for n in range(bullets_per_shot):
			var new_bullet = bullet_scene.instantiate()
			new_bullet.fire($BulletSpawnPosition.get_global_position(), get_global_rotation())
			get_tree().root.add_child(new_bullet)
		current_ammo -= 1
		can_fire = false

'''

#@onready var bullet_scene = preload("res://scenes/Projectiles/bullet.tscn")
#@onready var shot_effect: GPUParticles2D = $BodyRotate/ShootingEffect
#@onready var bulletSpawnPoint: Node2D = $BulletSpawnPoint
@onready var reloadTimer: Timer


signal applyKick(kickVector: Vector3)

var currentAmmo = 12
var maxAmmo = 12
var kickAmount = 5
var kickDuration = 0.015
var baseAccuracy = 0.95
var baseSpreadRate = 0.1
var bulletsPerShot = 1
var timeToReload = 1.0
var hasFlipped: bool = false
var hasTimeBetweenShots: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Timer setup
	reloadTimer = Timer.new()
	reloadTimer.set_one_shot(true)
	reloadTimer.connect("timeout", _on_reload_timer_timeout)
	reloadTimer.set_wait_time(timeToReload)
	add_child(reloadTimer)


func _physics_process(delta):
	if ( get_parent().is_in_group("player") ):
		if Input.is_action_just_pressed("shot"):
			shoot()
		if Input.is_action_just_pressed("reload"):
			reload()

		

func shoot():
	if (currentAmmo != 0):
		if (!reloadTimer.is_stopped()):
			reloadTimer.stop()
		# Shoot bullets per shot
		for n in range(bulletsPerShot):
			var bullet = bullet_scene.instantiate()
			var parentLayer = 1
			if ( get_parent().is_in_group("enemy") ):
				parentLayer = 4
			bullet.setup(bulletSpawnPoint.global_transform, parentLayer)
			
			# Give all shots randomness in spread and velocity
			var rot = bullet.get_rotation()
			bullet.set_rotation(rot + randf_range(-1 + baseAccuracy,1 - baseAccuracy))
			get_tree().root.add_child(bullet)
			bullet.speed *= randf_range(0.95,1.05)
		currentAmmo -= 1
		var rotX = -cos(rotation) * kickAmount
		var rotY = -sin(rotation) * kickAmount
		applyKick.emit(Vector3(rotX, rotY, kickDuration))
		#shot_effect.emitting = true
		# Play shoot sound
		#audio_player.play()


func reload():
	reloadTimer.start()


func _on_reload_timer_timeout():
	currentAmmo = maxAmmo
	reloadTimer.stop()

# Mirror node across y-axis when player aims left
func flip():
	var rot = global_rotation
	
	if ((rot >= PI/2 or rot <= -PI/2) and !hasFlipped):
		set_scale(Vector2(1,-1))
		hasFlipped = true
	
	if (rot <= PI/2 and rot >= -PI/2 and hasFlipped):
		set_scale(Vector2(1,1))
		hasFlipped = false
	
'''
