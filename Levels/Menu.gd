extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.tankskilled = 0
	Global.firstlevelcompleted = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene("res://Levels/Notice.tscn")

func _on_OptionsButton_pressed():
	get_tree().change_scene("res://Levels/Options.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()

