class_name weapon_3d
extends Node3D

#@onready var bullet_scene = preload("res://scenes/Projectiles/bullet.tscn")
#@onready var shot_effect: GPUParticles2D = $BodyRotate/ShootingEffect
#@onready var bulletSpawnPoint: Node2D = $BulletSpawnPoint
#@onready var reloadTimer: Timer

func _ready():
	pass

func use():
	pass
