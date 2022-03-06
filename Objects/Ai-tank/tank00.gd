extends KinematicBody

var speed = 15
var gravity = 100
var velocity = Vector3.ZERO
# onready var player = find_node("PlayerTank")  ## FIXME
onready var player = get_node("/root/Spatial/PlayerTank/CollisionShape")

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if player != null: # Makes sure player is not an empty variable (not equal to nill/null)
		$CollisionShape.look_at(Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z), Vector3(0,1,0))
		direction.z -= 1    ### CODE FROM HERE DOWN NEEDS IMPROVEMENT (AI walks up nonstop and not towards player...)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity.y -= gravity * delta
		velocity = move_and_slide(velocity, Vector3.UP)
	
