extends KinematicBody

export (PackedScene) var Bullet = preload("res://Objects/Bullet/Bullet.tscn")
var _bullettimer = null
var speed = 10
var gravity = 100
var velocity = Vector3.ZERO
onready var player = get_node("/root/Spatial/PlayerTank")

func _ready():  ##For bullet timer
	_bullettimer = Timer.new()
	add_child(_bullettimer)
	
	_bullettimer.connect("timeout", self, "_bullet_fire")
	_bullettimer.set_wait_time(1.0)
	_bullettimer.set_one_shot(false) # Make sure it loops
	_bullettimer.start()

func _physics_process(delta):
	velocity = Vector3.ZERO
	
	if player != null: # Makes sure player is not an empty variable (not equal to nill/null)
		$CollisionShape.look_at(Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z), Vector3(0,1,0)) # Look at player
		velocity = (player.transform.origin - transform.origin).normalized() * speed # make velocity direction equal to player direction
	velocity = move_and_slide(velocity) # Move AI towards player
	

func _bullet_fire():
	if player != null:
		var b = Bullet.instance()
		owner.add_child(b)
		b.transform = $CollisionShape/Tank/BulletGenerator.global_transform
		b.velocity = -b.global_transform.basis.z * b.muzzle_velocity
