extends KinematicBody

export (PackedScene) var Bullet = preload("res://Objects/Bullet/Bullet.tscn")
onready var camera = get_node("Camera")
var rayOrigin = Vector3()
var rayEnd = Vector3()
var speed = 15
var gravity = 100
var angular_acceleration = 7 # How fast the player rotates
var velocity = Vector3.ZERO

func _physics_process(delta):
	Global.player = self # Makes the player variable in the global script equal to self
	var direction = Vector3.ZERO
	### Input management
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_just_pressed("shoot"):
		var b = Bullet.instance()
		owner.add_child(b)
		b.transform = $CollisionShapeTop/Top_tank/BulletGenerator.global_transform
		b.velocity = -b.global_transform.basis.z * b.muzzle_velocity
	
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000 # Set cursor position to where the raycast hit
	var intersection = space_state.intersect_ray(rayOrigin, rayEnd) # Set variable for cursor position
	if not intersection.empty(): # Make sure there is a intersection with raycast
		var pos = intersection.position
		$CollisionShapeTop.look_at(Vector3(pos.x, $CollisionShapeTop.translation.y, pos.z), Vector3(0,1,0))
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
#		$Pivot.look_at(translation + direction, Vector3.UP)
	
	$CollisionShapeBottom.rotation.y = lerp_angle($CollisionShapeBottom.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
