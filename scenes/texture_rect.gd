extends TextureRect

var return_speed = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pan_camera(delta)
	
func pan_camera(delta):
	#var joy_input = Input.get("LookUp", "LookDown")
	#var is_input_active = false
	#
	#if joy_input.length() > 0:
		#is_input_active = true
		#
		#
		#
	#if not is_input_active:
		#position.y = lerp(position.y, 0, return_speed * delta)
		#
	if Input.is_action_pressed("TiltDown"):
		position.y -= 10
	
	if Input.is_action_pressed("TiltUp"):
		position.y += 10
		
		
	
