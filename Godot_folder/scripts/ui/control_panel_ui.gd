extends Control
class_name ControlPanelUI
## UI for interacting with control panels - drag and drop glyphs

# =============================================================================
# SIGNALS
# =============================================================================

signal closed

# =============================================================================
# STATE
# =============================================================================

var panel: ControlPanel = null
var slot_buttons: Array[Button] = []
var glyph_buttons: Array[Button] = []
var selected_slot: int = -1

# =============================================================================
# NODE REFERENCES
# =============================================================================

@onready var title_label: Label = $Panel/VBox/Title
@onready var description_label: Label = $Panel/VBox/Description
@onready var slots_container: HBoxContainer = $Panel/VBox/SlotsContainer
@onready var glyphs_container: GridContainer = $Panel/VBox/GlyphsContainer
@onready var submit_button: Button = $Panel/VBox/ButtonsContainer/SubmitButton
@onready var close_button: Button = $Panel/VBox/ButtonsContainer/CloseButton
@onready var feedback_label: Label = $Panel/VBox/Feedback

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	submit_button.pressed.connect(_on_submit_pressed)
	close_button.pressed.connect(_on_close_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()

# =============================================================================
# METHODS
# =============================================================================

## Setup the UI for a specific control panel
func setup(control_panel: ControlPanel) -> void:
	panel = control_panel

	# Update title and description
	title_label.text = "Control Panel"
	description_label.text = panel.panel_description

	# Create slot buttons
	_create_slots()

	# Create glyph buttons from discovered glyphs
	_create_glyph_buttons()

	# Clear feedback
	feedback_label.text = ""

## Create slot buttons based on panel solution size
func _create_slots() -> void:
	# Clear existing
	for child in slots_container.get_children():
		child.queue_free()
	slot_buttons.clear()

	# Create slots
	for i in range(panel.get_slot_count()):
		var slot = Button.new()
		slot.custom_minimum_size = Vector2(80, 80)
		slot.text = "[Empty]"

		# Check if already filled
		var placed = panel.get_placed_glyph(i)
		if placed != "":
			slot.text = placed

		slot.pressed.connect(_on_slot_pressed.bind(i))
		slots_container.add_child(slot)
		slot_buttons.append(slot)

## Create buttons for each discovered glyph
func _create_glyph_buttons() -> void:
	# Clear existing
	for child in glyphs_container.get_children():
		child.queue_free()
	glyph_buttons.clear()

	if not GlyphDatabase:
		return

	# Get discovered glyphs
	var discovered = GlyphDatabase.get_discovered_glyphs()

	for glyph in discovered:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(100, 50)

		# Show meaning if confirmed, otherwise just ID
		if glyph.confirmed:
			btn.text = "%s\n(%s)" % [glyph.id, glyph.correct_meaning]
		else:
			btn.text = glyph.id

		btn.pressed.connect(_on_glyph_pressed.bind(glyph.id))
		glyphs_container.add_child(btn)
		glyph_buttons.append(btn)

## Close the panel UI
func close() -> void:
	if GameManager:
		GameManager.set_game_state(GameManager.GameState.PLAYING)

	closed.emit()
	queue_free()

# =============================================================================
# EVENT HANDLERS
# =============================================================================

func _on_slot_pressed(slot_index: int) -> void:
	# If slot has glyph, remove it
	var current = panel.get_placed_glyph(slot_index)
	if current != "":
		panel.remove_glyph(slot_index)
		slot_buttons[slot_index].text = "[Empty]"
		feedback_label.text = "Removed %s from slot" % current
	else:
		# Select this slot
		selected_slot = slot_index
		feedback_label.text = "Select a glyph to place in slot %d" % (slot_index + 1)

		# Highlight selected slot
		for i in range(slot_buttons.size()):
			if i == slot_index:
				slot_buttons[i].modulate = Color(1, 1, 0.5, 1)
			else:
				slot_buttons[i].modulate = Color(1, 1, 1, 1)

func _on_glyph_pressed(glyph_id: String) -> void:
	if selected_slot < 0:
		# Find first empty slot
		for i in range(panel.get_slot_count()):
			if panel.get_placed_glyph(i) == "":
				selected_slot = i
				break

	if selected_slot >= 0:
		panel.place_glyph(selected_slot, glyph_id)
		slot_buttons[selected_slot].text = glyph_id
		slot_buttons[selected_slot].modulate = Color(1, 1, 1, 1)
		feedback_label.text = "Placed %s" % glyph_id
		selected_slot = -1
	else:
		feedback_label.text = "All slots are full! Click a slot to replace."

func _on_submit_pressed() -> void:
	if panel.submit():
		feedback_label.text = "CORRECT! Panel activated!"
		feedback_label.modulate = Color(0.3, 1, 0.3, 1)

		# Auto-close after delay
		await get_tree().create_timer(1.5).timeout
		close()
	else:
		feedback_label.text = "Incorrect sequence. Try again."
		feedback_label.modulate = Color(1, 0.3, 0.3, 1)

func _on_close_pressed() -> void:
	close()
