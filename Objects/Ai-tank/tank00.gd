extends KinematicBody

var speed = 15
var gravity = 100
var velocity = Vector3.ZERO
onready var player = find_node("PlayerTank")  ## FIXME

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if player != null: # Makes sure player is not an empty variable (not equal to nill/null)
		look_at(Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z), Vector3(0,1,0))
	
