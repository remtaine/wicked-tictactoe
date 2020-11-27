extends CanvasLayer

export (float) var transition_speed = 1.0
var path
var current_scene = null
var played_once = false
var with_transition

func _ready() -> void:
	$AnimationPlayer.playback_speed = transition_speed

func change_scene(p, wt := true):
	path = p
	with_transition = wt
#	if not played_once:
#		played_once = true
	if not with_transition:
		goto_scene(path)
	else:	
		$AnimationPlayer.play("enter")



#	$AnimationPlayer.play("Appear")
#	$AnimationPlayer.play_backwards("Appear")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "enter":
		goto_scene(path)
	elif anim_name == "exit":
		current_scene.activate()
#		var _scene_change_status = get_tree().change_scene(path)

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
#	played_once = false
	if not with_transition:
		current_scene.activate()
	else:	
		$AnimationPlayer.play("exit")
