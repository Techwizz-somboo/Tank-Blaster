extends CharacterBody3D

@export var Bullet = preload("res://Objects/Bullet/Bullet.tscn")
@onready var camera = get_node(^"Camera3D")
var rayOrigin = Vector3()
var rayEnd = Vector3()
var speed = 15
var gravity = 100
var angular_acceleration = 7 # How fast the player rotates

func _physics_process(delta):
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
	if Input.is_action_pressed("open_menu"):
		get_tree().change_scene("res://Levels/Main.tscn")
	if Input.is_action_just_pressed("shoot"):
		$AudioStreamPlayer3D.play()
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $CollisionShapeTop/Top_tank/BulletGenerator.global_transform
		b.velocity = -b.global_transform.basis.z * b.muzzle_velocity
	if (Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_back") || Input.is_action_pressed("move_forward")):
		$CollisionShapeBottom.rotation.y = lerp_angle($CollisionShapeBottom.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000 # Set cursor position to where the raycast hit
	#var intersection = space_state.intersect_ray(rayOrigin, rayEnd) # Set variable for cursor position
	#if not intersection.is_empty(): # Make sure there is a intersection with raycast
	#	var pos = intersection.position
	#	$CollisionShapeTop.look_at(Vector3(pos.x, $CollisionShapeTop.position.y, pos.z), Vector3(0,1,0))
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
#		$Pivot.look_at(position + direction, Vector3.UP)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	# TODO: This information should be set to the CharacterBody properties instead of arguments: , Vector3.UP
	# TODO: Rename velocity to linear_velocity in the rest of the script.
	move_and_slide()
