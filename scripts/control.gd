extends Control

func _ready() -> void:
	pass
	#_on_host_pressed()

func _on_host_pressed() -> void:
	print("Host Pressed")
	NetworkManager.host_game()
	hide() # Hide the menu so we can see the game
	ScoreManager.current_team_name = "HAHA NIX DA"
	
	#TODO - add in correct place:
	#func game_over():
	#	if multiplayer.is_server():
	#	ScoreManager.save_current_run()


func _on_join_pressed() -> void:
	print("Join Pressed")
	NetworkManager.join_game("127.0.0.1")
	hide()
