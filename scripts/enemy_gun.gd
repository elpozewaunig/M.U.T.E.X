extends Node3D

@onready var gun_ray = $RayCast3D
@onready var cooldown_timer = $CooldownTimer

var bulletScene = load("res://scenes/enemy_bullet.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func shoot_homing_missile(enemy_root_node: CharacterBody3D):	
	var bullet = bulletScene.instantiate()
	get_tree().root.add_child(bullet) 

	bullet.global_position = gun_ray.global_position
	bullet.global_transform.basis = gun_ray.global_transform.basis
	
	# Guns -> Visuals -> CharacterBody3D
	bullet.setup_bullet(enemy_root_node)
	
	
