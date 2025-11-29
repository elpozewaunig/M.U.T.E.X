extends Area3D

@export var speed := 125.0
@export var steer_force := 50.0 
@export var damage := 1000

var velocity := Vector3.ZERO
var current_target: Node3D = null

# Add @export so the MultiplayerSynchronizer can see it!
@export var shooter_is_host := false 

func _ready():
	$LifeTimer.timeout.connect(queue_free)
	

	body_entered.connect(_on_impact)


	if not multiplayer.is_server():
		set_physics_process(false) 
		await get_tree().process_frame # Wait for Synchronizer to update 'shooter_is_host'
		_apply_bullet_settings()
		set_physics_process(true) 


func setup_bullet(is_fired_by_host: bool, _shooter_node: Node3D):
	shooter_is_host = is_fired_by_host
	
	_apply_bullet_settings()

func _apply_bullet_settings():
	# Calculate velocity based on rotation (Forward is -Z)
	velocity = -global_transform.basis.z * speed
	
	# RESET MASKS
	collision_mask = 0
	$DetectionArea.collision_mask = 0
	
	# 1. ALWAYS HIT THE MAP
	set_collision_mask_value(1, true)
	
	if shooter_is_host:
		# --- HOST FIRED ---
		# Hit Enemy Type 2 (Layer 3)
		set_collision_mask_value(3, true)
		$DetectionArea.set_collision_mask_value(3, true)
		
		# FRIENDLY FIRE: Hit Client Player (Layer 5)
		set_collision_mask_value(5, true)
		
	else:
		# --- CLIENT FIRED ---
		# Hit Enemy Type 1 (Layer 2)
		set_collision_mask_value(2, true)
		$DetectionArea.set_collision_mask_value(2, true)
		
		# FRIENDLY FIRE: Hit Host Player (Layer 4)
		set_collision_mask_value(4, true)

func _physics_process(delta):
	# 1. FIND TARGET (If we don't have one)
	if not is_instance_valid(current_target):
		find_best_target()
	
	# 2. STEER TOWARDS TARGET
	if is_instance_valid(current_target):
		var target_dir = (current_target.global_position - global_position).normalized()
		
		var new_dir = velocity.normalized().slerp(target_dir, steer_force * delta)
		velocity = new_dir * speed
		
		look_at(global_position + velocity, Vector3.UP)

	# 3. MOVE
	position += velocity * delta

func find_best_target():
	var possible_targets = $DetectionArea.get_overlapping_bodies()
	if possible_targets.is_empty():
		return
		
	var closest_dist = INF
	var best_candidate = null
	
	for body in possible_targets:
		var dist = global_position.distance_to(body.global_position)
		if dist < closest_dist:
			closest_dist = dist
			best_candidate = body
			
	current_target = best_candidate

func _on_impact(body):
	if multiplayer.is_server():
		print("Bullet hit: ", body.name)
		if body.has_method("take_damage"):
			body.take_damage(damage)
	
	# Visual explosion can happen on clients, but deletion is server-authoritative
	if multiplayer.is_server():
		queue_free()
