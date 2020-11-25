extends Control

func _ready() -> void:
	pass
	
func next_turn() -> void:
	if GameInfo.current_turn == "blue":
		$PivotPivot/Pivot/AnimationPlayer.play("MoveLeft")
		GameInfo.current_turn = "red"
	else:
		$PivotPivot/Pivot/AnimationPlayer.play_backwards("MoveLeft")
		GameInfo.current_turn = "blue"
		
