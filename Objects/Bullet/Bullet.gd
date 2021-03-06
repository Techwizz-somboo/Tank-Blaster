extends Area

signal exploded

export var muzzle_velocity = 25 # How fast the bullets are
export var g = Vector3.DOWN * 20

var velocity = Vector3.ZERO

###### CHEATS
var godmode = 1


func _physics_process(delta):
#	velocity += g * delta  # Uncomment this for bullet gravity
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin += velocity * delta
	
	for body in get_overlapping_bodies():  ### HERE IS WHERE THE BULLET CHECKS FOR TANK COLLISIONS
		if get_overlapping_bodies().has(get_parent().get_node("PlayerTank")):
			print ("Found Player Tank")
			self.queue_free()
			if (godmode == 0):
				body.queue_free()
				Global.playerdead = 1
				Global.tankskilled = 0
				Global.beforedeathscene = get_tree().current_scene.filename
				get_tree().change_scene("res://Levels/Dead.tscn")
		else:
			if get_overlapping_bodies():
				if body.has_node("TankAI"):
					print ("Found AI Tank")
					Global.tankskilled = Global.tankskilled + 1
					if (Global.tankskilled == 10):
						if (Global.firstlevelcompleted == 0):
							Global.firstlevelcompleted = 1
							get_tree().change_scene("res://Levels/win-01.tscn")
						else:
							if (Global.firstlevelcompleted == 1):
								get_tree().change_scene("res://Levels/Win-02.tscn")
						Global.tankskilled = 0
					self.queue_free()
					body.queue_free()
				else:
						print ("Bullet Collided with something else")
						self.queue_free()


func _on_Shell_body_entered(body):
	emit_signal("exploded", transform.origin)
	queue_free()
