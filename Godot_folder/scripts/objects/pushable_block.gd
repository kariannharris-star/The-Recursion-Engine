extends CharacterBody2D
class_name PushableBlock
## A block that can be pushed by walking into it

@export var push_speed: float = 150.0
@export var push_distance: float = 32.0

var is_being_pushed: bool = false
var push_direction: Vector2 = Vector2.ZERO
var push_progress: float = 0.0

func _ready() -> void:
	add_to_group("pushable")
	if GameManager:
		GameManager.scale_changed.connect(_on_scale_changed)

func _physics_process(delta: float) -> void:
	if is_being_pushed:
		push_progress += push_speed * delta
		velocity = push_direction * push_speed
		move_and_slide()

		if push_progress >= push_distance:
			is_being_pushed = false
			velocity = Vector2.ZERO
			push_progress = 0.0

## Called when player collides - check if we should push
func try_push(player_pos: Vector2) -> bool:
	if is_being_pushed:
		return false

	# Check scale - can't push at micro
	if GameManager and GameManager.current_scale == GameManager.Scale.MICRO:
		print("[Block] Too heavy at this scale!")
		return false

	push_direction = (global_position - player_pos).normalized()
	# Snap to cardinal directions
	if abs(push_direction.x) > abs(push_direction.y):
		push_direction = Vector2(sign(push_direction.x), 0)
	else:
		push_direction = Vector2(0, sign(push_direction.y))

	is_being_pushed = true
	push_progress = 0.0
	print("[Block] Pushed!")
	return true

## For E interaction
func interact(player: Player) -> void:
	try_push(player.global_position)

func _on_scale_changed(new_scale) -> void:
	pass
