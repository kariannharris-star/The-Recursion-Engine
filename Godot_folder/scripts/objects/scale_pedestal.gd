extends Area2D
class_name ScalePedestal
## A pedestal that allows the player to shift between scales

# =============================================================================
# PROPERTIES
# =============================================================================

## Does this pedestal allow shifting to Micro scale?
@export var allows_micro: bool = true

## Does this pedestal allow shifting to Macro scale?
@export var allows_macro: bool = true


# =============================================================================
# STATE
# =============================================================================

var player_on_pedestal: bool = false
var current_player: Player = null

# =============================================================================
# NODE REFERENCES
# =============================================================================

@onready var sprite: Node2D = $Sprite2D
@onready var glow_effect: ColorRect = $Sprite2D/GlowEffect
@onready var inner_glow: ColorRect = $Sprite2D/InnerGlow

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	add_to_group("scale_pedestal")

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Update visual to show which scales are available
	_update_visual()

func _process(delta: float) -> void:
	# Pulse glow when player is on pedestal
	if player_on_pedestal:
		var pulse = (sin(Time.get_ticks_msec() / 200.0) + 1) / 2
		if glow_effect:
			glow_effect.modulate.a = 0.5 + pulse * 0.5
		if inner_glow:
			inner_glow.modulate.a = 0.7 + pulse * 0.3

# =============================================================================
# METHODS
# =============================================================================

## Called when player interacts (presses E)
func interact(player: Player) -> void:
	if player_on_pedestal:
		_try_scale_shift()

## Try to shift scale
func _try_scale_shift() -> void:
	if not GameManager:
		return

	var current = GameManager.current_scale
	var target: GameManager.Scale

	# Determine next scale in cycle
	match current:
		GameManager.Scale.NORMAL:
			if allows_micro:
				target = GameManager.Scale.MICRO
			elif allows_macro:
				target = GameManager.Scale.MACRO
			else:
				print("[ScalePedestal] No scale shifts available")
				return
		GameManager.Scale.MICRO:
			target = GameManager.Scale.NORMAL
		GameManager.Scale.MACRO:
			target = GameManager.Scale.NORMAL

	# Perform the shift
	GameManager.set_scale(target)
	print("[ScalePedestal] Shifted to: %s" % GameManager.get_scale_name())

	# Visual feedback
	_flash_glow()

## Flash the glow effect
func _flash_glow() -> void:
	if glow_effect:
		var tween = create_tween()
		tween.tween_property(glow_effect, "modulate", Color(1, 1, 1, 1), 0.1)
		tween.tween_property(glow_effect, "modulate", Color(1, 1, 1, 0.5), 0.3)

## Update visual to indicate available scales
func _update_visual() -> void:
	# Color coding based on available scales
	var color: Color
	if allows_micro and allows_macro:
		color = Color(0.6, 0.85, 0.95, 1)  # Cyan
	elif allows_micro:
		color = Color(0.5, 0.7, 0.95, 1)  # Blue
	elif allows_macro:
		color = Color(0.95, 0.6, 0.5, 1)  # Orange
	else:
		color = Color(0.6, 0.6, 0.6, 1)  # Gray

	if glow_effect:
		glow_effect.color = color * 0.9
		glow_effect.color.a = 0.7
	if inner_glow:
		inner_glow.color = color
		inner_glow.color.a = 0.9

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_on_pedestal = true
		current_player = body

		# Update player's room restrictions
		body.set_room_restrictions(allows_micro, allows_macro)

		print("[ScalePedestal] Player stepped on pedestal")
		print("[ScalePedestal] Press Shift to change scale")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_on_pedestal = false
		current_player = null
