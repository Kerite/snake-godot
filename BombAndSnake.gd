extends TileMap

const GameStatus = preload("res://Scripts/GameStatusEnum.gd").GameStatus
var bombs = []
var player1 = []
var player1_head = Vector2(-1, -1)
var player2 = []
var player2_head = Vector2(-1, -1)
var bomb_count = 0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Event Position:" + str(event.position) + ", Normal Position:" + str($"..".position))
			
			var clicked_cell = world_to_map(event.position - $"..".position)
			handle_cell_clicked(clicked_cell)

func handle_cell_clicked(cell: Vector2):
	if cell.x < 0 || cell.x > 4 || cell.y < 0 || cell.y > 4:
		return
	var root = $"../.."
	print(root.status)
	match root.status:
		GameStatus.READY, GameStatus.PENDING:
			var _cell = get_cellv(cell)
			if _cell == 0: # 本来是炸弹，则设置为不是炸弹
				set_cellv(cell, -1)
				bomb_count -= 1
				var bomb_position = bombs.find(cell)
				bombs.remove(bomb_position)
			elif _cell == -1: # 本来不是炸弹，设置为是炸弹
				if bomb_count >= ConfigData.bomb_num * 2:
					return
				set_cellv(cell, 0)
				bomb_count += 1
				bombs.append(cell)
			print(str(bomb_count) + " bombs placed, they are " + str(bombs))
			if bomb_count == ConfigData.bomb_num * 2:
				root.set_game_status(GameStatus.READY)
			else:
				root.set_game_status(GameStatus.PENDING)
		GameStatus.PLAYER_1:
			# 判断该玩家能否下在这个位置
			if !determine_cell(root.status, cell):
				print("玩家1不能下在这个位置 " + str(cell) + "")
				return
			player1.append(cell)
			continue
		GameStatus.PLAYER_2:
			# 判断该玩家能否下在这个位置
			if !determine_cell(root.status, cell):
				print("玩家2不能下在这个位置 " + str(cell) + "")
				return
			player2.append(cell)
			continue
		GameStatus.PLAYER_1, GameStatus.PLAYER_2:
			print("Current player: " + str(root.status))
			var current_player = root.status
			set_cellv(cell, current_player)
			if root.status == GameStatus.PLAYER_1:
				print("更新玩家1的蛇头为" + str(cell))
				player1_head = cell
				$Player1.position = Vector2(cell.x * 100 + 50, cell.y * 100 + 50)
				$Player1.visible = true
			elif root.status == GameStatus.PLAYER_2:
				print("更新玩家2的蛇头为" + str(cell))
				$Player2.position = Vector2(cell.x * 100 + 50, cell.y * 100 + 50)
				$Player2.visible = true
				player2_head = cell
			if bombs.find(cell) != -1:
				$"../../GameFinishedPanel/Bombed".text = "Player " + str(root.status) + " Bombed"
				root.set_game_status(GameStatus.FINISHED)
				return
			# 如果另一方还有地方落子，则继续游戏
			if !determain_player_is_dead(3 - current_player):
				root.set_game_status(3 - current_player)
			else:
				$"../../GameFinishedPanel/Bombed".text + str(3 - root.status) + " is dead"
				root.set_game_status(GameStatus.FINISHED)
			$PlayerScore1.text = str(player1.size())
			$PlayerScore2.text = str(player2.size())
		GameStatus.FINISHED:
			pass

# 判断是否能下在目标位置
func determine_cell(player: int, cell: Vector2) -> bool:
	var x = cell.x
	var y = cell.y
	if x < 0 || x > 4 || y < 0 || y > 4:
		return false
	
	var current_head = Vector2(-1, -1)
	if player == 1:
		current_head = player1_head
	elif player == 2:
		current_head = player2_head
	print("玩家" + str(player) + "的蛇头为" + str(current_head))
	
	# 第一步棋
	if current_head == Vector2(-1, -1):
		print("第一步")
		return true
	# 已经有其它棋子
	if (get_cellv(cell) != -1):
		print("该位置已经有其它棋子")
		return false
	# 判断是否紧邻蛇头
	if x == current_head.x && (y == current_head.y - 1 || y == current_head.y + 1):
		print("上下有蛇头")
		return true
	elif y == current_head.y && (x == current_head.x - 1 || x == current_head.x + 1):
		print("左右有蛇头")
		return true
	return false
	
func determain_player_is_dead(player: int) -> bool:
	var head = Vector2(-1, -1)
	match player:
		1: head = player1_head
		2: head = player2_head
	if head == Vector2(-1, -1):
		return false
	var x = head.x
	var y = head.y
	var flag = true
	for cell in [Vector2(x, y - 1), Vector2(x, y + 1), Vector2(x - 1, y), Vector2(x + 1, y)]:
		# 有一个位置能下
		if determine_cell(player, cell):
			flag = false
	return flag

func hide_all_bombs():
	print("Hiding all bombs")
	for bomb in bombs:
		set_cellv(bomb, -1)

func _ready():
	#var _cell_size = 500.0 / ConfigData.board_size
	#cell_size = Vector2(_cell_size, _cell_size)
	#$Player1.scale = Vector2(-_cell_size / 500, _cell_size / 500)
	#$Player2.scale = Vector2(_cell_size / 500, _cell_size / 500)
	pass
