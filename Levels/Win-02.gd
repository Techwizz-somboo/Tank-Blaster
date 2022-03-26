extends Control




func _on_Button_pressed():
	get_tree().quit()


func _on_ButtonMainMenu_pressed():
	get_tree().change_scene("res://Levels/Main.tscn")
