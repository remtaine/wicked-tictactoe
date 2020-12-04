class_name Level
extends Control

var menu_path = "res://src/menus/MainMenu.tscn"
var current_turn = "blue"
var filled_up_small_squares = 0

onready var small_square_capture_particle = preload("res://src/UI/SmallSquareCaptureParticle.tscn")
onready var big_square = $BigSquare
onready var big_square_grid = $BigSquare/Grid
onready var winner_label = $UI/UIControl/Labels/Winner
onready var turn_labels = $UI/UIControl/Labels/TurnLabels
onready var tween = $Addons/Tween

var has_winner = false


func _init() -> void:
	GameInfo.current_level = self
	
	
func _ready():
	winner_label.visible = false	
#	for small_squares in big_square_grid.get_children():
#		for tile in small_squares.get_children():
#			tile.visible = false
	set_process(false)
	set_physics_process(false)
		#TODO blue stuffff!


func activate():
	$Audio/Theme.play()
	GameInfo.current_turn = "blue"
	big_square.connect("changed_color",self, "_on_changed_color")
	for small_squares in big_square_grid.get_children():
		small_squares.connect("changed_color",self, "_on_changed_color")
		for tile in small_squares.get_children():
#			tile.visible = true			
			tile.get_node("ColorblindTiles").visible = GameInfo.in_colorblind_mode
			tile.intro()
			yield(get_tree().create_timer(0.04), "timeout")
	
	yield(get_tree().create_timer(0.4), "timeout")
	for small_squares in big_square_grid.get_children():
		for tile in small_squares.get_children():
			tile.is_clickable = true
	
	if GameInfo.is_blue_ai:
		ai_move() 

	set_process(true)
	set_physics_process(true)

func ai_move() -> void:
	pass
	#TODO
	#show thinking text
	#yield for a few
	#list current position as well as clickable positions
	var move_pos = get_move()
	#choose RANDOM (for now) among clickable positions
	manually_click(move_pos)
	#hide thinking text

func get_move() -> Vector2:
	return Vector2.ONE
	
func manually_click(move : Vector2) -> void:
	pass

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("menu"):
		if menu_path != "":
			get_tree().change_scene(menu_path)


func _on_changed_color(value, p, small_square_p) -> void:
	var pos = p[-1]
	var pos_int = int(pos)
	#TODO check if 3 in a row is made in the SmallSquare
	#check column n, n+3, n+6
	var modulo = pos_int % 3
	if modulo == 0:
		modulo = 3
	var dividend = ceil(pos_int / 3.0)

	dividend *= 3
	print("MATCHING FOR TILE: ", pos)
	
	print("CHECKING THE COLUMN: ", String(modulo), " ", String(modulo +3), " ", String(modulo + 6))
	print("CHECKING THE ROW: ", String(dividend), " ", String(dividend -1), " ", String(dividend -2))
	
	if is_three_in_a_row(small_square_p, modulo, modulo + 3, modulo + 6, value):
		print("column filled!")
		take_over_small_square(small_square_p, value, p)

	#check row 
	elif is_three_in_a_row(small_square_p, dividend, dividend - 1, dividend - 2, value):
		print("row filled!")
		take_over_small_square(small_square_p, value, p)
			
	#check diagonal
	elif pos_int in [1,5,9] and is_three_in_a_row(small_square_p, 1,5,9, value):
		print("diagonal filled!")
		take_over_small_square(small_square_p, value, p)
	elif pos_int in [3,5,7] and is_three_in_a_row(small_square_p, 3,5,7, value):
		print("diagonal filled!")
		take_over_small_square(small_square_p, value, p)
			
	#check if entire square is full
	elif big_square_grid.get_node(small_square_p).filled_up_tiles >= 8:
		take_over_small_square(small_square_p)
#	var is_square_full := true
#	for tile in big_square_grid.get_node(small_square_p).get_children():
#		if tile.current_value == -1:
#			is_square_full = false
#			break
#	if is_square_full:
#		take_over_small_square(small_square_p)
	#TODO check if 3 in a row in BigSquare
		
	if has_winner:
		return

	#sets up the next turn
	turn_labels.next_turn()
	
	if big_square_grid.get_node("SmallSquare" + pos).is_selectable:
		for small_square in big_square_grid.get_children():
			if small_square.get_name()[-1] == pos:
				for tile in small_square.get_children():
					tile.is_selectable = true
			else:
				for tile in small_square.get_children():
					tile.is_selectable = false
	else:
		for small_square in big_square_grid.get_children():
			for tile in small_square.get_children():
				tile.is_selectable = true
	#TODO check if AI then do if so
	
	
func show_big_win(value) -> void:
	var game_over = $UI/UIControl/Labels/GameOver
	var win_tween_duration := 0.6
	game_over.visible = true
	game_over.get_node("Tween").interpolate_property(game_over, "rect_position", game_over.rect_position + (Vector2.UP * 200), game_over.rect_position, win_tween_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	game_over.get_node("Tween").start()
	turn_labels.visible = false

	winner_label.visible = true
	var tween := $UI/UIControl/Labels/Winner/Tween
	tween.interpolate_property(winner_label,"rect_position", winner_label.rect_position + (Vector2.DOWN * 200), winner_label.rect_position, win_tween_duration,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	$UI/UIControl/Labels/Winner/MainMenuButton/AnimationPlayer.play("Blink")
	$UI/UIControl/Labels/Winner/RestartButton/AnimationPlayer.play("Blink")
	
	for small_square in big_square_grid.get_children():
			for tile in small_square.get_children():
				tile.is_selectable = false
				tile.is_clickable = false
	match value:
		0, 1:
			$Audio/Win.play()
			continue
		0: #ie blue
			winner_label.text += "blue"
			winner_label.self_modulate = GameInfo.blue
		1: #ie red
			winner_label.text += "red"
			winner_label.self_modulate = GameInfo.red			
		2: #ie yellow
			$Audio/Lose.play()
			$Audio/Theme.stop()
			winner_label.text += "no one"
			winner_label.self_modulate = GameInfo.yellow


func take_over_small_square(small_square_pos, value = null, tile_p = null) -> void:
	filled_up_small_squares += 1
	var small_square = big_square_grid.get_node(small_square_pos)
#	$Addons/Camera2D/Screenshake.start()
	
	if value == null:
		value = 2
	else: #spawns a nice one
		var particle = small_square_capture_particle.instance()
		particle.rect_position = get_global_mouse_position()
		particle.rect_position.x = clamp(particle.rect_position.x, 70, 470)
		add_child(particle)
#	if tile_p != null:
#		var tile = small_square.get_node(tile_p)
#		tile.tween.stop_all()
#		tile.get_node("TopTiles").scale = Vector2.ONE
		
	for tile in small_square.get_children():
		tile.capture(value)
#		tile.animate("top_rotation")

	small_square.current_value = value
	small_square.is_selectable = false
	
	#TODO check big square!
	if is_three_in_a_row_big(1,2,3,value) or is_three_in_a_row_big(4,5,6,value) or is_three_in_a_row_big(7,8,9,value):
		show_big_win(value)
		print("BIG WIN ROW")
	elif is_three_in_a_row_big(1,4,7,value) or is_three_in_a_row_big(2,5,8,value) or is_three_in_a_row_big(3,6,9,value):
		show_big_win(value)
		print("BIG WIN COLUMN")
	elif is_three_in_a_row_big(1,5,9,value) or is_three_in_a_row_big(3,5,7,value):
		show_big_win(value)
		print("BIG WIN DIAGONAL")
	elif filled_up_small_squares == 9:
		show_big_win(2)
		print("BIG WIN NO ONE :(")
	else:
		if value == 2:
			$Audio/CapturedNoOne.play()
		else:
			$Audio/Captured.play()
	
	var stored_rect_scale = small_square.rect_scale	
	tween.interpolate_property(small_square, "rect_scale", Vector2.ONE * 0.9, small_square.rect_scale * 1.03, 0.2, Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property(small_square, "rect_scale", small_square.rect_scale, stored_rect_scale, 0.3, Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	
	
func is_three_in_a_row_big(pos1, pos2, pos3, value) -> bool:
	var v1 = big_square_grid.get_node("SmallSquare" + String(pos1)).current_value
	var v2 = big_square_grid.get_node("SmallSquare" + String(pos2)).current_value
	var v3 = big_square_grid.get_node("SmallSquare" + String(pos3)).current_value
	
	if v1 == v2 and v2 == v3:
		if v1 == value:
			return true
	return false
	
	
func is_three_in_a_row(small_square, pos1, pos2, pos3, value = null) -> bool:
	var v1 = big_square_grid.get_node(small_square).get_node("BlankTile" + String(pos1)).current_value
	var v2 = big_square_grid.get_node(small_square).get_node("BlankTile" + String(pos2)).current_value
	var v3 = big_square_grid.get_node(small_square).get_node("BlankTile" + String(pos3)).current_value
	
	if v1 == v2 and v2 == v3:
		if value == null or v1 == value:
			return true
	return false
