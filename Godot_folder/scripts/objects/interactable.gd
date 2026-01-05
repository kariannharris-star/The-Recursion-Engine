extends Node2D
class_name Interactable
## Base class for all interactable objects in the game

# =============================================================================
# SIGNALS
# =============================================================================

signal interacted(player: Player)

# =============================================================================
# PROPERTIES
# =============================================================================

## Text shown when player is near (optional)
@export var interaction_hint: String = "Press E to interact"

## Can this be interacted with?
@export var is_active: bool = true

## Does this require a specific scale to interact?
@export var required_scale: GameManager.Scale = GameManager.Scale.NORMAL
@export var any_scale_allowed: bool = true

# =============================================================================
# METHODS
# =============================================================================

## Called when the player interacts with this object
## Override this in child classes
func interact(player: Player) -> void:
	if not is_active:
		return

	if not any_scale_allowed and GameManager.current_scale != required_scale:
		print("[%s] Wrong scale to interact" % name)
		return

	print("[%s] Interacted" % name)
	interacted.emit(player)
	_on_interact(player)

## Override this in child classes for specific behavior
func _on_interact(player: Player) -> void:
	pass

## Enable/disable this interactable
func set_active(active: bool) -> void:
	is_active = active
