extends Node2D

@onready var body = $Body

var jump_impulse: int = 10;
var horiz_move_force: int = 30;

var max_horiz_velocity: int = 500;

var draft_factor = 10.0

func _physics_process(delta):
	# Air Friction - Source:
	# https://forum.godotengine.org/t/how-to-set-a-max-speed-of-a-rigidbody2d/24941/2
	var center_body: RigidBody2D = body.get_center_body().rigidbody
	var sqrVelocity = center_body.linear_velocity.length() ** 2
	center_body.apply_impulse(Vector2(),center_body.linear_velocity.normalized() * sqrVelocity * -1 * delta * draft_factor)
	
	if Input.is_action_just_pressed("jump"):
		body.apply_impulse(Vector2(0, -jump_impulse))
	
	if Input.is_action_pressed("right"):
		body.constant_torque = 1000
		body.constant_force.x = 10
	elif Input.is_action_pressed("left"):
		body.constant_torque = -1000
		body.constant_force.x = -10
	else:
		body.constant_torque = 0
		body.constant_force.x = 0
		
	if Input.is_action_pressed("grasp"):
		body.physics_material_override.friction = 1.0
	else:
		# TODO: derive from initial value
		body.physics_material_override.friction = 0.1
	
	# TODO: move to level logic
	get_parent().get_node("CameraFollowPos").global_position = center_body.global_position
