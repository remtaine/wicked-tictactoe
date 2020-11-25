class_name StartButton
extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_MainMenuButton_pressed() -> void:
	$Audio/Clicked.play()
	$AnimationPlayer.stop(true)
	modulate = Color(1,1,1,1)
	$HBoxContainer.visible = true
#	yield(get_tree().create_timer(scene_change_delay), "timeout")
##	get_tree().get_root().get_children()[-1].get_node("Audio/Theme").stop()
#	get_tree().change_scene(level_path)
