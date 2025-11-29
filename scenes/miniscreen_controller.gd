extends Control

@export var emitter_path: NodePath

func _ready():
	var emitter = get_node(emitter_path)
	emitter.connect("zoomin", _on_my_signal)


func _on_my_signal():
	print("Signal received")
	$Placeholder.hide()
