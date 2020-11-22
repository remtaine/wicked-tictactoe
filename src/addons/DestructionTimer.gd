extends Timer


func _ready() -> void:
	pass


func _on_DestructionTimer_timeout() -> void:
	print("DEAD")
	get_parent().queue_free()
