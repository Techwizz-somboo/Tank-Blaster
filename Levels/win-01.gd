extends Control


func _physics_process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://Levels/Level02.tscn")
