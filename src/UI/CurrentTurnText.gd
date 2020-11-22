class_name CurrentTurnText
extends Label




func _ready() -> void:
	modulate = GameInfo.blue

func next_turn():
	if text == "Turn: Blue":
		text = "Turn: Red"
#		self.get_font()
#		set("custom_colors/font_color", red)
		modulate = GameInfo.red
	elif text == "Turn: Red":
		text = "Turn: Blue"
#		set("custom_colors/font_color", blue)
		modulate = GameInfo.blue
