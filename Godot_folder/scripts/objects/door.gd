extends StaticBody2D
class_name Door
## A door that can lead to another room or be locked

# =============================================================================
# SIGNALS
# =============================================================================

signal door_opened
signal door_closed
signal player_entered(target_room: String, spawn_point: String)

# =============================================================================
# PROPERTIES
# =============================================================================

## The room this door leads to
@export var target_room: String = ""

## The spawn point in the target room
@export var target_spawn: String = "default"

## Is this door currently locked?
@export var is_locked: bool = false

## Does this door require a specific scale to pass through?
@export var required_scale: GameManager.Scale = GameManager.Scale.NORMAL
@export var any_scale_allowed: bool = true

## Door type for visual representation
@export_enum("Normal", "Micro", "Macro") var door_type: int = 0

# =============================================================================
# STATE
# =============================================================================

var is_open: bool = false

# =============================================================================
# NODE REFERENCES
# =============================================================================

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var trigger_area: Area2D = $TriggerArea

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	add_to_group("doors")

	if trigger_area:
		trigger_area.body_entered.connect(_on_body_entered)

	_update_visual()

# =============================================================================
# METHODS
# =============================================================================

## Open the door
func open() -> void:
	if is_locked:
		print("[Door] Door is locked!")
		return

	is_open = true
	collision.set_deferred("disabled", true)
	_update_visual()
	door_opened.emit()
	print("[Door] Opened")

## Close the door
func close() -> void:
	is_open = false
	collision.set_deferred("disabled", false)
	_update_visual()
	door_closed.emit()
	print("[Door] Closed")

## Lock the door
func lock() -> void:
	is_locked = true
	close()

## Unlock the door
func unlock() -> void:
	is_locked = false
	print("[Door] Unlocked")

## Interact with the door
func interact(player: Player) -> void:
	if is_locked:
		print("[Door] This door is locked.")
		return

	if not any_scale_allowed and GameManager.current_scale != required_scale:
		print("[Door] You can't fit through at this scale.")
		return

	if not is_open:
		open()

## Update visual appearance
func _update_visual() -> void:
	if sprite:
		if is_open:
			sprite.modulate = Color(0.5, 0.5, 0.5, 0.5)  # Faded when open
		elif is_locked:
			sprite.modulate = Color(0.8, 0.3, 0.3, 1)  # Red tint when locked
		else:
			sprite.modulate = Color(0.6, 0.4, 0.2, 1)  # Brown for closed door

## Handle player entering the door trigger
func _on_body_entered(body: Node2D) -> void:
	if body is Player and is_open and target_room != "":
		# Check scale requirement
		if not any_scale_allowed and GameManager.current_scale != required_scale:
			return

		print("[Door] Player entering door to: %s" % target_room)
		player_entered.emit(target_room, target_spawn)

		# Trigger room change
		if GameManager:
			GameManager.change_room(target_room, target_spawn)
