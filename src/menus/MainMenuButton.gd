class_name MainMenuButton
extends Button

export var level_path = "res://src/levels/Level1.tscn"
export var is_animated_on_start = false
export var scene_change_delay = 1.0
func _ready() -> void:
	if is_animated_on_start:
		animate()

func animate():
	$AnimationPlayer.play("Blink")

func _on_MainMenuButton_pressed() -> void:
	$Audio/Clicked.play()
	$AnimationPlayer.playback_speed = 10
	yield(get_tree().create_timer(scene_change_delay), "timeout")
#	get_tree().get_root().get_children()[-1].get_node("Audio/Theme").stop()
	get_tree().change_scene(level_path)
