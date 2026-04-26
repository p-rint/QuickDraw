extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
var SPEED = 12.0
const SSPEED = 10.0
const JUMP_VELOCITY = 4

@onready var camPiv = $CamPivot
@onready var model = $Character
@onready var mesh: MeshInstance3D = $Character/MeshInstance3D
@onready var animPlr: AnimationPlayer = $AnimationPlayer
@onready var animTree: AnimationTree = $AnimationTree

var dt : float
var targetRot = 0
@export var health = 99
@export var coins : int = 0

var camForw : Vector3

enum States {IDLE, MOVE, FALLING}

var state = States.MOVE
func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

func move() -> void:
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, dt * 12)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, dt * 8)
		velocity.z = lerp(velocity.z, direction.z * SPEED, dt * 8)
		targetRot = atan2(-direction.x, -direction.z)
	else:
		if is_on_floor():
			velocity = lerp(velocity, Vector3.ZERO + Vector3(0,velocity.y,0), 8 * dt)
	#animTree.set("parameters/Run/blend_position", flatten(velocity).length()/SPEED)
	
	
func _physics_process(delta: float) -> void:
	dt = delta
	camForw = flatten($CamPivot.basis.z)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump()

	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	direction = flatten($CamPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	move()
	move_and_slide()
	

func jump() -> void:
	velocity.y = JUMP_VELOCITY
