class_name ToggleLabel
extends Label


export (String) var toggle_property = "in_colorblind_mode"
onready var check_button = $CheckButton

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_button.pressed = GameInfo.in_colorblind_mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	$Clicked.play()
	GameInfo.set(toggle_property, button_pressed)
	print("NOW AT " + String(GameInfo.get(toggle_property)))
