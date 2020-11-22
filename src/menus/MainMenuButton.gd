class_name MainMenuButton
extends Button

export var level_path = "res://src/levels/Level1.tscn"


func _ready() -> void:
	pass


func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene(level_path)
