extends Control
class_name NotebookUI
## Notebook UI - Displays discovered glyphs and allows hypotheses

# =============================================================================
# SIGNALS
# =============================================================================

signal notebook_closed

# =============================================================================
# NODE REFERENCES
# =============================================================================

@onready var glyph_list: VBoxContainer = $Panel/MarginContainer/HSplitContainer/GlyphList/ScrollContainer/VBoxContainer
@onready var glyph_details: VBoxContainer = $Panel/MarginContainer/HSplitContainer/GlyphDetails
@onready var glyph_name_label: Label = $Panel/MarginContainer/HSplitContainer/GlyphDetails/GlyphName
@onready var glyph_category_label: Label = $Panel/MarginContainer/HSplitContainer/GlyphDetails/Category
@onready var glyph_hint_label: Label = $Panel/MarginContainer/HSplitContainer/GlyphDetails/Hint
@onready var glyph_meaning_label: Label = $Panel/MarginContainer/HSplitContainer/GlyphDetails/Meaning
@onready var hypothesis_input: LineEdit = $Panel/MarginContainer/HSplitContainer/GlyphDetails/HypothesisInput
@onready var locations_label: Label = $Panel/MarginContainer/HSplitContainer/GlyphDetails/Locations

# =============================================================================
# STATE
# =============================================================================

var selected_glyph_id: String = ""
var is_open: bool = false

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	hide()

	# Connect to glyph discovery
	if GlyphDatabase:
		GlyphDatabase.glyph_discovered.connect(_on_glyph_discovered)
		GlyphDatabase.glyph_confirmed.connect(_on_glyph_confirmed)

	# Connect hypothesis input
	if hypothesis_input:
		hypothesis_input.text_submitted.connect(_on_hypothesis_submitted)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_notebook"):
		toggle()
	elif event.is_action_pressed("ui_cancel") and is_open:
		close()

# =============================================================================
# METHODS
# =============================================================================

## Toggle notebook open/closed
func toggle() -> void:
	if is_open:
		close()
	else:
		open()

## Open the notebook
func open() -> void:
	is_open = true
	show()
	refresh_glyph_list()

	if GameManager:
		GameManager.set_game_state(GameManager.GameState.IN_NOTEBOOK)

	print("[Notebook] Opened")

## Close the notebook
func close() -> void:
	is_open = false
	hide()

	if GameManager:
		GameManager.set_game_state(GameManager.GameState.PLAYING)

	notebook_closed.emit()
	print("[Notebook] Closed")

## Refresh the list of discovered glyphs
func refresh_glyph_list() -> void:
	if not glyph_list:
		return

	# Clear existing entries
	for child in glyph_list.get_children():
		child.queue_free()

	# Add discovered glyphs
	if GlyphDatabase:
		var discovered = GlyphDatabase.get_discovered_glyphs()

		if discovered.is_empty():
			var empty_label = Label.new()
			empty_label.text = "No glyphs discovered yet.\nExplore the temple to find symbols."
			glyph_list.add_child(empty_label)
		else:
			for glyph in discovered:
				var button = Button.new()
				button.text = _format_glyph_button_text(glyph)
				button.pressed.connect(_on_glyph_selected.bind(glyph.id))
				glyph_list.add_child(button)

## Format the button text for a glyph
func _format_glyph_button_text(glyph: GlyphDatabase.GlyphData) -> String:
	var status = ""
	if glyph.confirmed:
		status = " [Confirmed]"
	elif glyph.player_hypothesis != "":
		status = " [?]"

	return "[%s] %s%s" % [glyph.category.left(3), glyph.id, status]

## Show details for a selected glyph
func _show_glyph_details(glyph_id: String) -> void:
	if not GlyphDatabase:
		return

	var glyph = GlyphDatabase.get_glyph(glyph_id)
	if not glyph:
		return

	selected_glyph_id = glyph_id

	# Update labels
	if glyph_name_label:
		glyph_name_label.text = glyph.id

	if glyph_category_label:
		glyph_category_label.text = "Category: %s" % glyph.category

	if glyph_hint_label:
		glyph_hint_label.text = glyph.hint_text

	if glyph_meaning_label:
		if glyph.confirmed:
			glyph_meaning_label.text = "Meaning: %s (Confirmed)" % glyph.correct_meaning
			glyph_meaning_label.modulate = Color(0.3, 0.9, 0.3, 1)
		else:
			glyph_meaning_label.text = "Meaning: ???"
			glyph_meaning_label.modulate = Color(1, 1, 1, 1)

	if hypothesis_input:
		hypothesis_input.text = glyph.player_hypothesis
		hypothesis_input.editable = not glyph.confirmed

	if locations_label:
		if glyph.locations_found.is_empty():
			locations_label.text = "Found: Unknown location"
		else:
			locations_label.text = "Found: %s" % ", ".join(glyph.locations_found)

# =============================================================================
# EVENT HANDLERS
# =============================================================================

func _on_glyph_selected(glyph_id: String) -> void:
	_show_glyph_details(glyph_id)

func _on_hypothesis_submitted(text: String) -> void:
	if selected_glyph_id != "" and GlyphDatabase:
		GlyphDatabase.set_hypothesis(selected_glyph_id, text)
		print("[Notebook] Hypothesis set for %s: %s" % [selected_glyph_id, text])
		refresh_glyph_list()

func _on_glyph_discovered(glyph_id: String) -> void:
	if is_open:
		refresh_glyph_list()

func _on_glyph_confirmed(glyph_id: String) -> void:
	if is_open:
		refresh_glyph_list()
		if selected_glyph_id == glyph_id:
			_show_glyph_details(glyph_id)
