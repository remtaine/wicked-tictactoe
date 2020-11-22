extends Control

func _ready() -> void:
	pass
	
func next_turn() -> void:
	if GameInfo.current_turn == "blue":
		$Pivot/AnimationPlayer.play("MoveLeft")
		GameInfo.current_turn = "red"
	else:
		$Pivot/AnimationPlayer.play_backwards("MoveLeft")
		GameInfo.current_turn = "blue"
		
