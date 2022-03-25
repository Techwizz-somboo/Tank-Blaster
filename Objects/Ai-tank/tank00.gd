extends KinematicBody

export (PackedScene) var Bullet = preload("res://Objects/Bullet/Bullet.tscn")

## Timer vars
#Bullets
var _bullettimer = null
var bullettime = null
var bulletrandomnum = RandomNumberGenerator.new()
#Walking
var _walkingtimer = null
var walkingtime = null
var walkingrandomnum = RandomNumberGenerator.new()
var ablewalk = 0

var speed = 10
var gravity = 100
var velocity = Vector3.ZERO
var angular_acceleration = 7 # How fast the tank rotates
onready var player = get_node("/root/Spatial/PlayerTank")

func _ready():  
	##For bullet timer
	_bullettimer = Timer.new()
	add_child(_bullettimer)
	bulletrandomnum.randomize()
	bullettime = bulletrandomnum.randf_range(1.0, 5.0)
	_bullettimer.connect("timeout", self, "_bullet_fire")
	_bullettimer.set_wait_time(bullettime)
	_bullettimer.set_one_shot(false) # Make sure it loops
	_bullettimer.start()
	
	##For walking timer
	_walkingtimer = Timer.new()
	add_child(_walkingtimer)
	walkingrandomnum.randomize()
	walkingtime = walkingrandomnum.randf_range(1.0, 10.0)
	_walkingtimer.connect("timeout", self, "_walk_towards_player_timer")
	_walkingtimer.set_wait_time(walkingtime)
	_walkingtimer.set_one_shot(false) # Make sure it loops
	_walkingtimer.start()

func _physics_process(delta):
	velocity = Vector3.ZERO
	if ablewalk == 1:
		_walk_towards_player()
		$CollisionShapeBottom.rotation.y = lerp_angle($CollisionShapeBottom.rotation.y, atan2(velocity.x, velocity.z), delta * angular_acceleration)
	_look_at_player()
	velocity.y -= gravity * delta

func _bullet_fire():
	if player != null:
		$AudioStreamPlayer3D.play()
		var b = Bullet.instance()
		owner.add_child(b)
		b.transform = $CollisionShapeTop/Top_tank/BulletGenerator.global_transform
		b.velocity = -b.global_transform.basis.z * b.muzzle_velocity
		
		bulletrandomnum.randomize()
		bullettime = bulletrandomnum.randf_range(1.0, 5.0)
		_bullettimer.set_wait_time(bullettime)

func _walk_towards_player():
	if player != null: # Makes sure player is not an empty variable (not equal to nill/null)
		if Global.playerdead == 0:
			velocity = (player.transform.origin - transform.origin).normalized() * speed # make velocity direction equal to player direction
	velocity = move_and_slide(velocity) # Move AI towards player

func _look_at_player():
	if player != null:
		if Global.playerdead == 0:
			$CollisionShapeTop.look_at(Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z), Vector3(0,1,0)) # Look at player

func _walk_towards_player_timer():
	walkingrandomnum.randomize()
	walkingtime = walkingrandomnum.randf_range(1.0, 10.0)
	_walkingtimer.set_wait_time(walkingtime)
	if ablewalk == 1:
		ablewalk = 0
	else:
		if ablewalk == 0:
			ablewalk = 1
		else:
			print("I guess randomized walking might have broke...")
