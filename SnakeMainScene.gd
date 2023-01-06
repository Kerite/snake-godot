extends Node2D

const GameStatus = preload("res://Scripts/GameStatusEnum.gd").GameStatus
var status = GameStatus.PENDING

func set_game_status(_status):
	var previous_status = status
	if (previous_status != _status):
		print("New game status is " + str(_status) + ", old game status is " + str(previous_status))
	status = _status
	match status:
		GameStatus.PENDING:
			$GameStatusLabel.text = "Placing Bombs"
		GameStatus.READY:
			$GameStatusLabel.text = "Ready to start"
		GameStatus.PLAYER_1:
			if previous_status == GameStatus.READY:
				$"BoardMap/BombAndSnake".hide_all_bombs()
			$GameStatusLabel.text = "Player 1"
		GameStatus.PLAYER_2:
			$GameStatusLabel.text = "Player 2"
		GameStatus.FINISHED:
			$GameStatusLabel.text = "Finished"
	if status == GameStatus.READY:
		$GameStartButton.visible = true
	else:
		$GameStartButton.visible = false
		if status == GameStatus.FINISHED:
			$GameFinishedPanel.visible = true

func _ready():
	#var _cell_size = 500.0 / ConfigData.board_size
	#$BoardMap.cell_size = Vector2(_cell_size, _cell_size)
	set_game_status(GameStatus.PENDING)

func _on_PlayAgainButton_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_BackMenuButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
	pass # Replace with function body.

func _on_GameStartButton_pressed():
	set_game_status(GameStatus.PLAYER_1)
	pass # Replace with function body.
