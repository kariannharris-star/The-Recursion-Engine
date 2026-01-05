extends Node
## Glyph Database - Stores all glyph data and player discovery progress
## Glyphs are descriptive labels that help players understand the world

# =============================================================================
# SIGNALS
# =============================================================================

signal glyph_discovered(glyph_id: String)
signal glyph_confirmed(glyph_id: String)
signal hypothesis_updated(glyph_id: String, hypothesis: String)

# =============================================================================
# GLYPH DATA STRUCTURE
# =============================================================================

## Represents a single glyph and its discovery state
class GlyphData:
	var id: String                    # Unique identifier (e.g., "AQUA")
	var category: String              # Category (SUBSTANCE, STATE, ACTION, etc.)
	var correct_meaning: String       # The actual meaning
	var discovered: bool = false      # Has player seen this glyph?
	var confirmed: bool = false       # Has player confirmed meaning via quiz?
	var player_hypothesis: String = "" # Player's guess at the meaning
	var locations_found: Array[String] = []  # Where the glyph was found
	var hint_text: String             # Contextual hint for learning

	func _init(p_id: String, p_category: String, p_meaning: String, p_hint: String = "") -> void:
		id = p_id
		category = p_category
		correct_meaning = p_meaning
		hint_text = p_hint

# =============================================================================
# GLYPH CATEGORIES
# =============================================================================

const CATEGORY_SUBSTANCE := "SUBSTANCE"  # What things are made of
const CATEGORY_STATE := "STATE"          # Conditions and qualities
const CATEGORY_ACTION := "ACTION"        # What happens
const CATEGORY_PERCEPTION := "PERCEPTION" # Understanding
const CATEGORY_TEMPORAL := "TEMPORAL"    # Time-related
const CATEGORY_MODIFIER := "MODIFIER"    # Grammar/logic modifiers

# =============================================================================
# GLYPH REGISTRY
# =============================================================================

## All glyphs in the game, keyed by ID
var glyphs: Dictionary = {}

## Tutorial glyphs (first 5 learned in Dungeon 1)
var tutorial_glyphs: Array[String] = ["AQUA", "PETRA", "FLOW", "STASIS", "APERIRE"]

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	_initialize_glyphs()
	print("[GlyphDatabase] Initialized with %d glyphs" % glyphs.size())

## Initialize all glyphs in the game
func _initialize_glyphs() -> void:
	# =========================================================================
	# SUBSTANCE GLYPHS (6) - What things are made of
	# =========================================================================
	_add_glyph("AQUA", CATEGORY_SUBSTANCE, "Water",
		"Found near fountains, pools, and water channels")
	_add_glyph("PETRA", CATEGORY_SUBSTANCE, "Stone",
		"Carved on boulders and stone structures")
	_add_glyph("IGNIS", CATEGORY_SUBSTANCE, "Fire",
		"Appears near flames and heat sources")
	_add_glyph("GLACIES", CATEGORY_SUBSTANCE, "Ice",
		"Found in cold areas and frozen surfaces")
	_add_glyph("AETHER", CATEGORY_SUBSTANCE, "Air",
		"Associated with wind and open spaces")
	_add_glyph("FERRUM", CATEGORY_SUBSTANCE, "Metal",
		"Carved on gears and mechanisms")

	# =========================================================================
	# STATE GLYPHS (6) - Conditions and qualities
	# =========================================================================
	_add_glyph("FLOW", CATEGORY_STATE, "Movement",
		"Seen on flowing water and moving parts")
	_add_glyph("STASIS", CATEGORY_STATE, "Still",
		"Found on still pools and stopped mechanisms")
	_add_glyph("LUMEN", CATEGORY_STATE, "Light",
		"Associated with illumination and visibility")
	_add_glyph("UMBRA", CATEGORY_STATE, "Dark",
		"Found in shadowy and hidden areas")
	_add_glyph("MAGNUS", CATEGORY_STATE, "Large",
		"Indicates expansion or great size")
	_add_glyph("PARVUS", CATEGORY_STATE, "Small",
		"Indicates reduction or tiny size")

	# =========================================================================
	# ACTION GLYPHS (6) - What happens
	# =========================================================================
	_add_glyph("ASCENDE", CATEGORY_ACTION, "Rise",
		"Points upward, associated with rising water or platforms")
	_add_glyph("DESCENDE", CATEGORY_ACTION, "Fall",
		"Points downward, associated with draining or lowering")
	_add_glyph("ROTARE", CATEGORY_ACTION, "Turn",
		"Found on rotating mechanisms and gears")
	_add_glyph("APERIRE", CATEGORY_ACTION, "Open",
		"Carved on doors and locks that can be opened")
	_add_glyph("CLAUDERE", CATEGORY_ACTION, "Close",
		"Found on sealing mechanisms and closing doors")
	_add_glyph("MUTARE", CATEGORY_ACTION, "Change",
		"Associated with transformation and state changes")

	# =========================================================================
	# PERCEPTION GLYPHS (4) - Understanding
	# =========================================================================
	_add_glyph("VISIO", CATEGORY_PERCEPTION, "Sight",
		"Eye-like symbol related to seeing and observation")
	_add_glyph("AUDIO", CATEGORY_PERCEPTION, "Sound",
		"Wave pattern related to hearing and echoes")
	_add_glyph("TACTUS", CATEGORY_PERCEPTION, "Touch",
		"Related to physical interaction and pressure")
	_add_glyph("MENSURA", CATEGORY_PERCEPTION, "Measure",
		"Related to scale, proportion, and size")

	# =========================================================================
	# TEMPORAL GLYPHS (3) - Time-related
	# =========================================================================
	_add_glyph("TEMPUS", CATEGORY_TEMPORAL, "Time",
		"Cyclical symbol representing passage of time")
	_add_glyph("MORA", CATEGORY_TEMPORAL, "Delay",
		"Indicates waiting or pause before action")
	_add_glyph("CELERITAS", CATEGORY_TEMPORAL, "Speed",
		"Indicates rapid or immediate action")

	# =========================================================================
	# MODIFIER GLYPHS (4) - Grammar/Logic
	# =========================================================================
	_add_glyph("CIRCLE", CATEGORY_MODIFIER, "Continuous",
		"Circle around a glyph means 'always' or 'eternal'")
	_add_glyph("TRIANGLE", CATEGORY_MODIFIER, "Conditional",
		"Triangle around a glyph means 'if' or 'when'")
	_add_glyph("NEGATE", CATEGORY_MODIFIER, "Not",
		"Line through a glyph means 'opposite' or 'negation'")
	_add_glyph("EMPHASIS", CATEGORY_MODIFIER, "Required",
		"Double border means 'must' or 'required'")

## Helper to add a glyph to the registry
func _add_glyph(id: String, category: String, meaning: String, hint: String) -> void:
	glyphs[id] = GlyphData.new(id, category, meaning, hint)

# =============================================================================
# DISCOVERY SYSTEM
# =============================================================================

## Mark a glyph as discovered (player has seen it)
func discover_glyph(glyph_id: String, location: String = "") -> void:
	if not glyphs.has(glyph_id):
		push_error("[GlyphDatabase] Unknown glyph: %s" % glyph_id)
		return

	var glyph: GlyphData = glyphs[glyph_id]

	if not glyph.discovered:
		glyph.discovered = true
		print("[GlyphDatabase] Discovered glyph: %s" % glyph_id)
		glyph_discovered.emit(glyph_id)

	# Track where it was found
	if location != "" and not glyph.locations_found.has(location):
		glyph.locations_found.append(location)

## Confirm a glyph's meaning (player passed quiz)
func confirm_glyph(glyph_id: String) -> void:
	if not glyphs.has(glyph_id):
		return

	var glyph: GlyphData = glyphs[glyph_id]
	if not glyph.confirmed:
		glyph.confirmed = true
		print("[GlyphDatabase] Confirmed glyph: %s = %s" % [glyph_id, glyph.correct_meaning])
		glyph_confirmed.emit(glyph_id)

## Set player's hypothesis for a glyph's meaning
func set_hypothesis(glyph_id: String, hypothesis: String) -> void:
	if not glyphs.has(glyph_id):
		return

	var glyph: GlyphData = glyphs[glyph_id]
	glyph.player_hypothesis = hypothesis
	hypothesis_updated.emit(glyph_id, hypothesis)

# =============================================================================
# QUERY METHODS
# =============================================================================

## Get a glyph by ID
func get_glyph(glyph_id: String) -> GlyphData:
	return glyphs.get(glyph_id)

## Get all discovered glyphs
func get_discovered_glyphs() -> Array[GlyphData]:
	var result: Array[GlyphData] = []
	for glyph in glyphs.values():
		if glyph.discovered:
			result.append(glyph)
	return result

## Get all confirmed glyphs
func get_confirmed_glyphs() -> Array[GlyphData]:
	var result: Array[GlyphData] = []
	for glyph in glyphs.values():
		if glyph.confirmed:
			result.append(glyph)
	return result

## Get glyphs by category
func get_glyphs_by_category(category: String) -> Array[GlyphData]:
	var result: Array[GlyphData] = []
	for glyph in glyphs.values():
		if glyph.category == category:
			result.append(glyph)
	return result

## Check if a glyph is discovered
func is_discovered(glyph_id: String) -> bool:
	if not glyphs.has(glyph_id):
		return false
	return glyphs[glyph_id].discovered

## Check if a glyph is confirmed
func is_confirmed(glyph_id: String) -> bool:
	if not glyphs.has(glyph_id):
		return false
	return glyphs[glyph_id].confirmed

## Get the correct meaning of a glyph (for quiz validation)
func get_meaning(glyph_id: String) -> String:
	if not glyphs.has(glyph_id):
		return ""
	return glyphs[glyph_id].correct_meaning

## Check if player's hypothesis matches the correct meaning
func check_hypothesis(glyph_id: String) -> bool:
	if not glyphs.has(glyph_id):
		return false
	var glyph: GlyphData = glyphs[glyph_id]
	return glyph.player_hypothesis.to_lower() == glyph.correct_meaning.to_lower()

# =============================================================================
# TUTORIAL HELPERS
# =============================================================================

## Get the tutorial glyphs (first 5)
func get_tutorial_glyphs() -> Array[GlyphData]:
	var result: Array[GlyphData] = []
	for glyph_id in tutorial_glyphs:
		if glyphs.has(glyph_id):
			result.append(glyphs[glyph_id])
	return result

## Check if all tutorial glyphs are discovered
func all_tutorial_glyphs_discovered() -> bool:
	for glyph_id in tutorial_glyphs:
		if not is_discovered(glyph_id):
			return false
	return true

## Check if all tutorial glyphs are confirmed
func all_tutorial_glyphs_confirmed() -> bool:
	for glyph_id in tutorial_glyphs:
		if not is_confirmed(glyph_id):
			return false
	return true

# =============================================================================
# SAVE/LOAD
# =============================================================================

## Get save data for all glyphs
func get_save_data() -> Dictionary:
	var data := {}
	for glyph_id in glyphs:
		var glyph: GlyphData = glyphs[glyph_id]
		data[glyph_id] = {
			"discovered": glyph.discovered,
			"confirmed": glyph.confirmed,
			"hypothesis": glyph.player_hypothesis,
			"locations": glyph.locations_found
		}
	return data

## Load save data for all glyphs
func load_save_data(data: Dictionary) -> void:
	for glyph_id in data:
		if glyphs.has(glyph_id):
			var glyph: GlyphData = glyphs[glyph_id]
			var glyph_data: Dictionary = data[glyph_id]
			glyph.discovered = glyph_data.get("discovered", false)
			glyph.confirmed = glyph_data.get("confirmed", false)
			glyph.player_hypothesis = glyph_data.get("hypothesis", "")
			glyph.locations_found.assign(glyph_data.get("locations", []))
	print("[GlyphDatabase] Loaded save data")
