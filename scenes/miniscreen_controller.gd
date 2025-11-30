extends Control

@export var emitter_path: NodePath
@export var zoomoutanim: AnimationPlayer
func _ready():
	var emitter = get_node(emitter_path)
	emitter.connect("zoomin", _on_my_signal)

func _on_my_signal():
	print("Signal received")
	$Placeholder.hide()

func _on_button_pressed() -> void:
		zoomoutanim.play("zoomback") #es grubert GANZ schlimm
