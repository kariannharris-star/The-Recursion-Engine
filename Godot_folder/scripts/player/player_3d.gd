extends CharacterBody3D
class_name Player3D
## 3D Player Controller - Top-down gameplay with 3D graphics

const MOVE_SPEED := 5.0
const SCALE_TRANSITION_TIME := 0.3

@onready var mesh: Node3D = $Mesh
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var interaction_area: Area3D = $InteractionArea

var facing_direction: Vector3 = Vector3.FORWARD
var can_move: bool = true
var is_scaling: bool = false
var current_interactable: Node = null
var room_allows_micro: bool = true
var room_allows_macro: bool = true

func _ready() -> void:
	if GameManager:
		GameManager.scale_changed.connect(_on_scale_changed)
		GameManager.game_state_changed.connect(_on_game_state_changed)

	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
		interaction_area.area_entered.connect(_on_area_entered)
		interaction_area.area_exited.connect(_on_area_exited)

	_apply_scale(GameManager.current_scale if GameManager else GameManager.Scale.NORMAL)
	print("[Player3D] Ready")

func _physics_process(delta: float) -> void:
	if not can_move or is_scaling:
		return
	if GameManager and not GameManager.is_playing():
		return

	var input_dir := _get_input_direction()

	if input_dir != Vector3.ZERO:
		facing_direction = input_dir.normalized()
		velocity = input_dir.normalized() * MOVE_SPEED
		_update_interaction_area()

		# Rotate mesh to face movement direction
		if mesh:
			mesh.rotation.y = atan2(facing_direction.x, facing_direction.z)
	else:
		velocity = Vector3.ZERO

	# Keep Y velocity at 0 for top-down
	velocity.y = 0
	move_and_slide()
	_check_push_collision()

func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return

	if event.is_action_pressed("interact"):
		_try_interact()
	if event.is_action_pressed("scale_shift"):
		_try_scale_shift()
	if event.is_action_pressed("open_notebook"):
		_open_notebook()

func _get_input_direction() -> Vector3:
	var dir := Vector3.ZERO
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("ui_up"):
		dir.z -= 1
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("ui_down"):
		dir.z += 1
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		dir.x += 1
	return dir

func _check_push_collision() -> void:
	for i in get_slide_collision_count():
		var collision_info = get_slide_collision(i)
		var collider = collision_info.get_collider()
		if collider.has_method("try_push"):
			collider.try_push(global_position)

func _update_interaction_area() -> void:
	if interaction_area:
		interaction_area.position = facing_direction * 0.8

func _try_interact() -> void:
	if current_interactable and current_interactable.has_method("interact"):
		current_interactable.interact(self)
		if GameManager:
			GameManager.interaction_triggered.emit(current_interactable)

func _on_body_entered(body: Node) -> void:
	if body.has_method("interact") and body != self:
		current_interactable = body

func _on_body_exited(body: Node) -> void:
	if body == current_interactable:
		current_interactable = null

func _on_area_entered(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent and parent.has_method("interact"):
		current_interactable = parent

func _on_area_exited(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent == current_interactable:
		current_interactable = null

func _try_scale_shift() -> void:
	if is_scaling or not _is_on_pedestal():
		return
	if GameManager:
		GameManager.cycle_scale(room_allows_micro, room_allows_macro)

func _is_on_pedestal() -> bool:
	if interaction_area:
		for area in interaction_area.get_overlapping_areas():
			if area.is_in_group("scale_pedestal"):
				return true
	return false

func _on_scale_changed(new_scale: GameManager.Scale) -> void:
	_animate_scale_change(new_scale)

func _animate_scale_change(new_scale: GameManager.Scale) -> void:
	is_scaling = true
	can_move = false
	var target_scale = GameManager.get_scale_multiplier()

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector3.ONE * target_scale, SCALE_TRANSITION_TIME)
	tween.tween_callback(func():
		is_scaling = false
		can_move = true
	)

func _apply_scale(scale_state: GameManager.Scale) -> void:
	var scale_mult = GameManager.SCALE_MULTIPLIERS[scale_state]
	scale = Vector3.ONE * scale_mult

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	can_move = (new_state == GameManager.GameState.PLAYING)

func _open_notebook() -> void:
	if GameManager:
		GameManager.set_game_state(GameManager.GameState.IN_NOTEBOOK)

func set_room_restrictions(allows_micro: bool, allows_macro: bool) -> void:
	room_allows_micro = allows_micro
	room_allows_macro = allows_macro

func spawn_at(pos: Vector3) -> void:
	global_position = pos
	velocity = Vector3.ZERO
