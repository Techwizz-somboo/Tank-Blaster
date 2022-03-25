extends VBoxContainer


func _physics_process(delta):
	$Score.text = str(Global.tankskilled)
