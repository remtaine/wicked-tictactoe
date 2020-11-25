class_name OnePButton
extends MainMenuButton

func _on_MainMenuButton_pressed() -> void:
	GameInfo.is_red_ai = true
	#TODO make it diferent for red and blue!
	._on_MainMenuButton_pressed()
