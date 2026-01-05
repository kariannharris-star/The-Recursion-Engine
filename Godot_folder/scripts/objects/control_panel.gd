extends Node2D
class_name ControlPanel
## Control Panel - Glyph-based puzzle interface
## Players drag glyphs to slots to activate mechanisms

# =============================================================================
# SIGNALS
# =============================================================================

signal panel_solved(sequence: Array[String])
signal panel_failed

# =============================================================================
# PROPERTIES
# =============================================================================

## The correct sequence of glyph IDs to solve this panel
@export var solution: Array[String] = []

## Description/hint shown on the panel
@export var panel_description: String = "Arrange the glyphs correctly."

## What mechanism does this panel control?
@export var target_mechanism: NodePath = ""

## Is this panel already solved?
var is_solved: bool = false

## Currently placed glyphs (slot index -> glyph_id)
var placed_glyphs: Dictionary = {}

# =============================================================================
# NODE REFERENCES
# =============================================================================

@onready var interaction_area: Area2D = $InteractionArea
@onready var visual: Sprite2D = $Visual

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	add_to_group("control_panels")

	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)

	# Initialize slots
	for i in range(solution.size()):
		placed_glyphs[i] = ""

## Called when player interacts
func interact(player: Player) -> void:
	if is_solved:
		print("[ControlPanel] This panel is already solved.")
		return

	# Open the panel UI
	open_panel_ui()

## Open the control panel UI
func open_panel_ui() -> void:
	print("[ControlPanel] Opening panel interface...")
	print("[ControlPanel] %s" % panel_description)
	print("[ControlPanel] Solution requires %d glyphs" % solution.size())

	if GameManager:
		GameManager.set_game_state(GameManager.GameState.IN_PUZZLE)

	# Create and show the panel UI
	var panel_ui = preload("res://scenes/ui/control_panel_ui.tscn").instantiate()
	panel_ui.setup(self)
	get_tree().root.add_child(panel_ui)

## Place a glyph in a slot
func place_glyph(slot_index: int, glyph_id: String) -> void:
	if slot_index >= 0 and slot_index < solution.size():
		placed_glyphs[slot_index] = glyph_id
		print("[ControlPanel] Placed %s in slot %d" % [glyph_id, slot_index])

## Remove a glyph from a slot
func remove_glyph(slot_index: int) -> void:
	if placed_glyphs.has(slot_index):
		placed_glyphs[slot_index] = ""

## Check if all slots are filled
func is_complete() -> bool:
	for i in range(solution.size()):
		if placed_glyphs.get(i, "") == "":
			return false
	return true

## Submit the current arrangement
func submit() -> bool:
	if not is_complete():
		print("[ControlPanel] Not all slots are filled!")
		return false

	# Check solution
	var correct = true
	for i in range(solution.size()):
		if placed_glyphs.get(i, "") != solution[i]:
			correct = false
			break

	if correct:
		_on_solved()
		return true
	else:
		_on_failed()
		return false

## Called when panel is solved
func _on_solved() -> void:
	is_solved = true
	print("[ControlPanel] CORRECT! Panel solved!")

	# Visual feedback
	if visual:
		visual.modulate = Color(0.3, 0.9, 0.3, 1)

	# Activate target mechanism
	if target_mechanism != "":
		var mechanism = get_node_or_null(target_mechanism)
		if mechanism and mechanism.has_method("activate"):
			mechanism.activate()

	panel_solved.emit(solution)

	if GameManager:
		GameManager.set_game_state(GameManager.GameState.PLAYING)

## Called when panel submission fails
func _on_failed() -> void:
	print("[ControlPanel] Incorrect sequence. Try again.")

	# Visual feedback
	if visual:
		var tween = create_tween()
		tween.tween_property(visual, "modulate", Color(0.9, 0.3, 0.3, 1), 0.1)
		tween.tween_property(visual, "modulate", Color(1, 1, 1, 1), 0.3)

	panel_failed.emit()

## Get the current state for UI
func get_slot_count() -> int:
	return solution.size()

func get_placed_glyph(slot_index: int) -> String:
	return placed_glyphs.get(slot_index, "")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("[ControlPanel] Press E to interact with panel")
