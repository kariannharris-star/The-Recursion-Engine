extends Node
## Glyph Database - Stores all glyph data and player discovery progress
## Glyphs use SYMBOLS, not words

# =============================================================================
# SIGNALS
# =============================================================================

signal glyph_discovered(glyph_symbol: String)
signal glyph_confirmed(glyph_symbol: String)
signal hypothesis_updated(glyph_symbol: String, hypothesis: String)

# =============================================================================
# GLYPH DATA STRUCTURE
# =============================================================================

## Represents a single glyph and its discovery state
class GlyphData:
	var symbol: String                # The symbol itself (e.g., "≋")
	var category: String              # Category (SUBSTANCE, STATE, ACTION, etc.)
	var meaning: String               # The actual meaning
	var discovered: bool = false      # Has player seen this glyph?
	var confirmed: bool = false       # Has player confirmed meaning via quiz?
	var player_hypothesis: String = "" # Player's guess at the meaning
	var locations_found: Array[String] = []  # Where the glyph was found
	var hint_text: String             # Contextual hint for learning

	func _init(p_symbol: String, p_category: String, p_meaning: String, p_hint: String = "") -> void:
		symbol = p_symbol
		category = p_category
		meaning = p_meaning
		hint_text = p_hint

# =============================================================================
# GLYPH CATEGORIES
# =============================================================================

const CATEGORY_SUBSTANCE := "SUBSTANCE"  # What things are made of
const CATEGORY_STATE := "STATE"          # Conditions and qualities
const CATEGORY_ACTION := "ACTION"        # What happens
const CATEGORY_MODIFIER := "MODIFIER"    # Grammar/logic modifiers

# =============================================================================
# GLYPH REGISTRY
# =============================================================================

## All glyphs in the game, keyed by symbol
var glyphs: Dictionary = {}

## Tutorial glyphs (first 5 learned in Dungeon 1)
var tutorial_glyphs: Array[String] = ["≋", "◆", "⇝", "◯", "⊏⊐"]

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	_initialize_glyphs()
	print("[GlyphDatabase] Initialized with %d glyphs" % glyphs.size())

## Initialize all glyphs in the game
func _initialize_glyphs() -> void:
	# =========================================================================
	# SUBSTANCE GLYPHS - What things are made of
	# =========================================================================
	_add_glyph("≋", CATEGORY_SUBSTANCE, "Water",
		"Found near fountains, pools, and water channels")
	_add_glyph("◆", CATEGORY_SUBSTANCE, "Stone",
		"Carved on boulders and stone structures")
	_add_glyph("⨳", CATEGORY_SUBSTANCE, "Fire",
		"Appears near flames and heat sources")
	_add_glyph("❄", CATEGORY_SUBSTANCE, "Ice",
		"Found in cold areas and frozen surfaces")
	_add_glyph("≈", CATEGORY_SUBSTANCE, "Air",
		"Associated with wind and open spaces")
	_add_glyph("⚙", CATEGORY_SUBSTANCE, "Metal",
		"Carved on gears and mechanisms")

	# =========================================================================
	# STATE GLYPHS - Conditions and qualities
	# =========================================================================
	_add_glyph("⇝", CATEGORY_STATE, "Flow",
		"Seen on flowing water and moving parts")
	_add_glyph("◯", CATEGORY_STATE, "Still",
		"Found on still pools and stopped mechanisms")
	_add_glyph("✦", CATEGORY_STATE, "Light",
		"Associated with illumination and visibility")
	_add_glyph("●", CATEGORY_STATE, "Dark",
		"Found in shadowy and hidden areas")
	_add_glyph("△", CATEGORY_STATE, "Large",
		"Indicates expansion or great size")
	_add_glyph("▽", CATEGORY_STATE, "Small",
		"Indicates reduction or tiny size")

	# =========================================================================
	# ACTION GLYPHS - What happens
	# =========================================================================
	_add_glyph("↑", CATEGORY_ACTION, "Rise",
		"Points upward, associated with rising water or platforms")
	_add_glyph("↓", CATEGORY_ACTION, "Fall",
		"Points downward, associated with draining or lowering")
	_add_glyph("↻", CATEGORY_ACTION, "Turn",
		"Found on rotating mechanisms and gears")
	_add_glyph("⊏⊐", CATEGORY_ACTION, "Open",
		"Carved on doors and locks that can be opened")
	_add_glyph("⊐⊏", CATEGORY_ACTION, "Close",
		"Found on sealing mechanisms and closing doors")
	_add_glyph("⇌", CATEGORY_ACTION, "Change",
		"Associated with transformation and state changes")

	# =========================================================================
	# MODIFIER GLYPHS - Grammar/Logic
	# =========================================================================
	_add_glyph("○", CATEGORY_MODIFIER, "Continuous",
		"Circle around a glyph means 'always' or 'eternal'")
	_add_glyph("▲", CATEGORY_MODIFIER, "Conditional",
		"Triangle around a glyph means 'if' or 'when'")
	_add_glyph("—", CATEGORY_MODIFIER, "Not",
		"Line through a glyph means 'opposite' or 'negation'")
	_add_glyph("◈", CATEGORY_MODIFIER, "Required",
		"Double border means 'must' or 'required'")

## Helper to add a glyph to the registry
func _add_glyph(symbol: String, category: String, meaning: String, hint: String) -> void:
	glyphs[symbol] = GlyphData.new(symbol, category, meaning, hint)

# =============================================================================
# DISCOVERY SYSTEM
# =============================================================================

## Mark a glyph as discovered (player has seen it)
func discover_glyph(glyph_symbol: String, location: String = "") -> void:
	if not glyphs.has(glyph_symbol):
		# Create a new unknown glyph entry
		_add_glyph(glyph_symbol, "UNKNOWN", "???", "Unknown symbol")
		glyphs[glyph_symbol].discovered = true
		print("[GlyphDatabase] Discovered new symbol: %s" % glyph_symbol)
		glyph_discovered.emit(glyph_symbol)
		return

	var glyph: GlyphData = glyphs[glyph_symbol]

	if not glyph.discovered:
		glyph.discovered = true
		print("[GlyphDatabase] Discovered: %s" % glyph_symbol)
		glyph_discovered.emit(glyph_symbol)

	# Track where it was found
	if location != "" and not glyph.locations_found.has(location):
		glyph.locations_found.append(location)

## Confirm a glyph's meaning (player passed quiz)
func confirm_glyph(glyph_symbol: String) -> void:
	if not glyphs.has(glyph_symbol):
		return

	var glyph: GlyphData = glyphs[glyph_symbol]
	if not glyph.confirmed:
		glyph.confirmed = true
		print("[GlyphDatabase] Confirmed: %s = %s" % [glyph_symbol, glyph.meaning])
		glyph_confirmed.emit(glyph_symbol)

## Set player's hypothesis for a glyph's meaning
func set_hypothesis(glyph_symbol: String, hypothesis: String) -> void:
	if not glyphs.has(glyph_symbol):
		return

	var glyph: GlyphData = glyphs[glyph_symbol]
	glyph.player_hypothesis = hypothesis
	hypothesis_updated.emit(glyph_symbol, hypothesis)

# =============================================================================
# QUERY METHODS
# =============================================================================

## Get a glyph by symbol
func get_glyph(glyph_symbol: String) -> GlyphData:
	return glyphs.get(glyph_symbol)

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
func is_discovered(glyph_symbol: String) -> bool:
	if not glyphs.has(glyph_symbol):
		return false
	return glyphs[glyph_symbol].discovered

## Check if a glyph is confirmed
func is_confirmed(glyph_symbol: String) -> bool:
	if not glyphs.has(glyph_symbol):
		return false
	return glyphs[glyph_symbol].confirmed

## Get the meaning of a glyph (for quiz validation)
func get_meaning(glyph_symbol: String) -> String:
	if not glyphs.has(glyph_symbol):
		return ""
	return glyphs[glyph_symbol].meaning

## Check if player's hypothesis matches the correct meaning
func check_hypothesis(glyph_symbol: String) -> bool:
	if not glyphs.has(glyph_symbol):
		return false
	var glyph: GlyphData = glyphs[glyph_symbol]
	return glyph.player_hypothesis.to_lower() == glyph.meaning.to_lower()

# =============================================================================
# TUTORIAL HELPERS
# =============================================================================

## Get the tutorial glyphs (first 5)
func get_tutorial_glyphs() -> Array[GlyphData]:
	var result: Array[GlyphData] = []
	for symbol in tutorial_glyphs:
		if glyphs.has(symbol):
			result.append(glyphs[symbol])
	return result

## Check if all tutorial glyphs are discovered
func all_tutorial_glyphs_discovered() -> bool:
	for symbol in tutorial_glyphs:
		if not is_discovered(symbol):
			return false
	return true

## Check if all tutorial glyphs are confirmed
func all_tutorial_glyphs_confirmed() -> bool:
	for symbol in tutorial_glyphs:
		if not is_confirmed(symbol):
			return false
	return true

# =============================================================================
# SAVE/LOAD
# =============================================================================

## Get save data for all glyphs
func get_save_data() -> Dictionary:
	var data := {}
	for symbol in glyphs:
		var glyph: GlyphData = glyphs[symbol]
		data[symbol] = {
			"discovered": glyph.discovered,
			"confirmed": glyph.confirmed,
			"hypothesis": glyph.player_hypothesis,
			"locations": glyph.locations_found
		}
	return data

## Load save data for all glyphs
func load_save_data(data: Dictionary) -> void:
	for symbol in data:
		if glyphs.has(symbol):
			var glyph: GlyphData = glyphs[symbol]
			var glyph_data: Dictionary = data[symbol]
			glyph.discovered = glyph_data.get("discovered", false)
			glyph.confirmed = glyph_data.get("confirmed", false)
			glyph.player_hypothesis = glyph_data.get("hypothesis", "")
			glyph.locations_found.assign(glyph_data.get("locations", []))
	print("[GlyphDatabase] Loaded save data")
