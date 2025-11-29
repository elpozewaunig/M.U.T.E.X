extends Node3D

@onready var gun_ray = $RayCast3D
@onready var cooldown_timer = $CooldownTimer

var bulletScene = load("res://scenes/enemy_bullet.tscn")
var bulletObject
var is_shooting = false

func _ready() -> void:
	cooldown_timer.start()

func _process(_delta: float) -> void:
	pass

func shoot_homing_missile():
	
	if not cooldown_timer.is_stopped():
		# cooldown timer has not expired yet
		return
	
	var bullet = bulletScene.instantiate()
	get_tree().root.add_child(bullet) 

	bullet.global_position = gun_ray.global_position
	bullet.global_transform.basis = gun_ray.global_transform.basis
	
	var visuals_node = get_parent()
	var enemy_root_node = visuals_node.get_parent()
	if enemy_root_node is CharacterBody3D:
		bullet.setup_bullet(enemy_root_node)
		cooldown_timer.start()
	
	
