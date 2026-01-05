extends CharacterBody3D
class_name PushableBlock3D
## 3D Pushable block

@export var push_speed: float = 3.0
@export var push_distance: float = 1.0

var is_being_pushed: bool = false
var push_direction: Vector3 = Vector3.ZERO
var push_progress: float = 0.0

func _ready() -> void:
	add_to_group("pushable")

func _physics_process(delta: float) -> void:
	if is_being_pushed:
		push_progress += push_speed * delta
		velocity = push_direction * push_speed
		velocity.y = 0
		move_and_slide()

		if push_progress >= push_distance:
			is_being_pushed = false
			velocity = Vector3.ZERO
			push_progress = 0.0

func try_push(player_pos: Vector3) -> bool:
	if is_being_pushed:
		return false

	if GameManager and GameManager.current_scale == GameManager.Scale.MICRO:
		print("[Block3D] Too heavy at this scale!")
		return false

	push_direction = (global_position - player_pos).normalized()
	push_direction.y = 0

	# Snap to cardinal directions
	if abs(push_direction.x) > abs(push_direction.z):
		push_direction = Vector3(sign(push_direction.x), 0, 0)
	else:
		push_direction = Vector3(0, 0, sign(push_direction.z))

	is_being_pushed = true
	push_progress = 0.0
	print("[Block3D] Pushed!")
	return true

func interact(player) -> void:
	try_push(player.global_position)
