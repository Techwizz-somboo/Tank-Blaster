extends KinematicBody

var speed = 10
var gravity = 100
var velocity = Vector3.ZERO
onready var player = get_node("/root/Spatial/PlayerTank")

func _physics_process(delta):
	velocity = Vector3.ZERO
	
	if player != null: # Makes sure player is not an empty variable (not equal to nill/null)
		$CollisionShape.look_at(Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z), Vector3(0,1,0)) # Look at player
		velocity = (player.transform.origin - transform.origin).normalized() * speed # make velocity direction equal to player direction
	velocity = move_and_slide(velocity) # Move AI towards player
	
