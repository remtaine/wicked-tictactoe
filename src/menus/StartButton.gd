class_name StartButton
extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var has_clicked_once = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_MainMenuButton_pressed() -> void:
	if not has_clicked_once:
		$Audio/Clicked.play()
		$AnimationPlayer.stop(true)
		modulate = Color(1,1,1,1)
		$HBoxContainer.visible = true
		has_clicked_once = true
#	yield(get_tree().create_timer(scene_change_delay), "timeout")
##	get_tree().get_root().get_children()[-1].get_node("Audio/Theme").stop()
#	get_tree().change_scene(level_path)
