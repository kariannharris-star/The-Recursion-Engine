extends CharacterBody2D
class_name Player
## Player Controller - Handles movement, interaction, and scale shifting
## The player explores the temple, learns glyphs, and solves puzzles

# =============================================================================
# CONSTANTS
# =============================================================================

const MOVE_SPEED := 200.0  # Base movement speed in pixels/second
const SCALE_TRANSITION_TIME := 0.3  # Time for scale change animation

# =============================================================================
# NODE REFERENCES
# =============================================================================

@onready var sprite: Node2D = $Sprite2D
@onready var body_visual: ColorRect = $Sprite2D/Body
@onready var direction_indicator: ColorRect = $Sprite2D/DirectionIndicator
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# =============================================================================
# STATE
# =============================================================================

## Current facing direction (for interaction detection)
var facing_direction: Vector2 = Vector2.DOWN

## Is the player currently able to move?
var can_move: bool = true

## Is the player currently transitioning scale?
var is_scaling: bool = false

## Current interactable object in range (if any)
var current_interactable: Node = null

## Room scale restrictions
var room_allows_micro: bool = true
var room_allows_macro: bool = true

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	# Connect to game manager signals
	if GameManager:
		GameManager.scale_changed.connect(_on_scale_changed)
		GameManager.game_state_changed.connect(_on_game_state_changed)

	# Set up interaction area
	if interaction_area:
		interaction_area.body_entered.connect(_on_interaction_area_entered)
		interaction_area.body_exited.connect(_on_interaction_area_exited)
		interaction_area.area_entered.connect(_on_interaction_area_area_entered)
		interaction_area.area_exited.connect(_on_interaction_area_area_exited)

	# Apply initial scale
	_apply_scale(GameManager.current_scale if GameManager else GameManager.Scale.NORMAL)

	print("[Player] Ready")

func _physics_process(delta: float) -> void:
	if not can_move or is_scaling:
		return

	# Only process movement when in PLAYING state
	if GameManager and not GameManager.is_playing():
		return

	# Get input and move
	var input_dir := _get_input_direction()

	if input_dir != Vector2.ZERO:
		# Update facing direction
		facing_direction = input_dir.normalized()

		# Calculate velocity
		velocity = input_dir.normalized() * MOVE_SPEED

		# Update interaction area position based on facing
		_update_interaction_area()
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Check for pushable blocks after movement
	_check_push_collision()

func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return

	# Interaction (E key or Space)
	if event.is_action_pressed("interact"):
		_try_interact()

	# Scale shift (Shift key) - only when on a pedestal
	if event.is_action_pressed("scale_shift"):
		_try_scale_shift()

	# Open notebook (Q key)
	if event.is_action_pressed("open_notebook"):
		_open_notebook()

	# Quick glossary (Tab key)
	if event.is_action_pressed("quick_glossary"):
		_toggle_glossary()

# =============================================================================
# MOVEMENT
# =============================================================================

## Check if we collided with a pushable block
func _check_push_collision() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is PushableBlock:
			collider.try_push(global_position)

## Get the current input direction as a Vector2
func _get_input_direction() -> Vector2:
	var dir := Vector2.ZERO

	# Support both WASD and arrow keys
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		dir.x += 1

	return dir

## Update the interaction area position based on facing direction
func _update_interaction_area() -> void:
	if not interaction_area:
		return

	# Position the interaction area in front of the player
	interaction_area.position = facing_direction * 24  # 24 pixels in front

	# Update direction indicator position
	if direction_indicator:
		direction_indicator.position = facing_direction * 16 - Vector2(4, 3)

# =============================================================================
# INTERACTION
# =============================================================================

## Try to interact with the current interactable
func _try_interact() -> void:
	if current_interactable and current_interactable.has_method("interact"):
		print("[Player] Interacting with: %s" % current_interactable.name)
		current_interactable.interact(self)
		if GameManager:
			GameManager.interaction_triggered.emit(current_interactable)

func _on_interaction_area_entered(body: Node) -> void:
	if body.has_method("interact") and body != self:
		current_interactable = body
		print("[Player] Interactable in range: %s" % body.name)

func _on_interaction_area_exited(body: Node) -> void:
	if body == current_interactable:
		current_interactable = null

func _on_interaction_area_area_entered(area: Area2D) -> void:
	# Check if the area's parent is interactable
	var parent = area.get_parent()
	if parent and parent.has_method("interact"):
		current_interactable = parent
		print("[Player] Interactable area in range: %s" % parent.name)

func _on_interaction_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == current_interactable:
		current_interactable = null

# =============================================================================
# SCALE SHIFTING
# =============================================================================

## Try to shift scale (called when on a pedestal)
func _try_scale_shift() -> void:
	if is_scaling:
		return

	# Check if we're on a scale pedestal
	if not _is_on_pedestal():
		print("[Player] Cannot shift scale - not on a pedestal")
		return

	# Try to cycle scale
	if GameManager:
		var success = GameManager.cycle_scale(room_allows_micro, room_allows_macro)
		if not success:
			print("[Player] Cannot shift to that scale in this room")

## Check if the player is standing on a scale pedestal
func _is_on_pedestal() -> bool:
	# Check for overlapping pedestal areas
	if interaction_area:
		for area in interaction_area.get_overlapping_areas():
			if area.is_in_group("scale_pedestal"):
				return true

	# Also check bodies
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collision_mask = 0b00010000  # Layer 5 for pedestals
	var result = space_state.intersect_point(query)

	return result.size() > 0

## Called when GameManager scale changes
func _on_scale_changed(new_scale: GameManager.Scale) -> void:
	_animate_scale_change(new_scale)

## Animate the scale transition
func _animate_scale_change(new_scale: GameManager.Scale) -> void:
	is_scaling = true
	can_move = false

	var target_scale = GameManager.get_scale_multiplier()

	# Create scale tween
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)

	# Animate sprite scale
	tween.tween_property(sprite, "scale", Vector2.ONE * target_scale, SCALE_TRANSITION_TIME)

	# Also scale collision shape
	if collision_shape:
		tween.parallel().tween_property(collision_shape, "scale", Vector2.ONE * target_scale, SCALE_TRANSITION_TIME)

	# Re-enable movement after transition
	tween.tween_callback(func():
		is_scaling = false
		can_move = true
		_update_collision_layers(new_scale)
	)

## Apply scale immediately (used on spawn)
func _apply_scale(scale_state: GameManager.Scale) -> void:
	var scale_mult = GameManager.SCALE_MULTIPLIERS[scale_state]
	if sprite:
		sprite.scale = Vector2.ONE * scale_mult
	if collision_shape:
		collision_shape.scale = Vector2.ONE * scale_mult
	_update_collision_layers(scale_state)

## Update collision layers based on current scale
func _update_collision_layers(scale_state: GameManager.Scale) -> void:
	# Layer 1: Universal (always collide)
	# Layer 2: Normal-only obstacles
	# Layer 3: Micro-only passages
	# Layer 4: Macro-only obstacles

	match scale_state:
		GameManager.Scale.NORMAL:
			collision_mask = 0b0011  # Layers 1 and 2
		GameManager.Scale.MICRO:
			collision_mask = 0b0101  # Layers 1 and 3
		GameManager.Scale.MACRO:
			collision_mask = 0b1001  # Layers 1 and 4

# =============================================================================
# UI
# =============================================================================

## Open the notebook UI
func _open_notebook() -> void:
	if GameManager:
		GameManager.set_game_state(GameManager.GameState.IN_NOTEBOOK)
	# The notebook scene will handle the rest

## Toggle the quick glossary
func _toggle_glossary() -> void:
	# Quick reference overlay - implemented in UI system
	pass

# =============================================================================
# GAME STATE
# =============================================================================

func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	# Disable movement when not in PLAYING state
	can_move = (new_state == GameManager.GameState.PLAYING)

# =============================================================================
# ROOM SETUP
# =============================================================================

## Set room-specific scale restrictions
func set_room_restrictions(allows_micro: bool, allows_macro: bool) -> void:
	room_allows_micro = allows_micro
	room_allows_macro = allows_macro

## Spawn at a specific position
func spawn_at(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
