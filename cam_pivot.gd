extends Node3D

var dt : float

var mouseLock = false

@onready var cam : Camera3D = $Camera3D

@onready var player: CharacterBody3D = $".."
@onready var startPos = cam.position
var camOffset : Vector3 =  Vector3(0,0,0)


func _ready() -> void:
	Input.mouse_mode = (Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not mouseLock:
		rotation.y -= event.relative.x * .001 #Left <-> Right
		rotation.x -= event.relative.y * .001 #Up <-> Down
		rotation.y = wrapf(rotation.y, -PI, PI)
		rotation.x = clampf(rotation.x,-PI/2,PI/2)
			
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("Tab"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_released("Tab"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	dt = delta
	cam.position = startPos + camOffset
