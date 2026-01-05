extends Node2D
class_name GlyphStone
## A surface with a glyph carved on it that players can discover

# =============================================================================
# PROPERTIES
# =============================================================================

## The glyph ID displayed on this stone
@export var glyph_id: String = "AQUA"

## Description shown when interacting
@export var description: String = "An ancient symbol is carved here."

## Has the player already examined this?
var has_been_examined: bool = false

# =============================================================================
# NODE REFERENCES
# =============================================================================

@onready var sprite: Sprite2D = $Sprite2D
@onready var glyph_display: Sprite2D = $GlyphDisplay
@onready var interaction_area: Area2D = $InteractionArea

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	add_to_group("glyph_stones")

	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)

	# Draw the glyph symbol
	_draw_glyph()

# =============================================================================
# METHODS
# =============================================================================

## Called when player interacts
func interact(player: Player) -> void:
	examine()

## Examine the glyph
func examine() -> void:
	print("[GlyphStone] Examining glyph: %s" % glyph_id)
	print("[GlyphStone] %s" % description)

	# Discover the glyph
	if GlyphDatabase:
		var location = get_parent().name if get_parent() else "unknown"
		GlyphDatabase.discover_glyph(glyph_id, location)

	has_been_examined = true

	# Visual feedback
	if glyph_display:
		# Glow effect when discovered
		var tween = create_tween()
		tween.tween_property(glyph_display, "modulate", Color(1, 1, 0.5, 1), 0.3)
		tween.tween_property(glyph_display, "modulate", Color(1, 1, 1, 1), 0.3)

## Auto-discover when player gets close
func _on_body_entered(body: Node2D) -> void:
	if body is Player and not has_been_examined:
		examine()

## Draw the glyph symbol (placeholder - geometric shapes)
func _draw_glyph() -> void:
	if not glyph_display:
		return

	# Set color based on glyph category
	var glyph = GlyphDatabase.get_glyph(glyph_id) if GlyphDatabase else null
	if glyph:
		match glyph.category:
			"SUBSTANCE":
				glyph_display.modulate = Color(0.3, 0.6, 0.9, 1)  # Blue
			"STATE":
				glyph_display.modulate = Color(0.3, 0.9, 0.3, 1)  # Green
			"ACTION":
				glyph_display.modulate = Color(0.9, 0.6, 0.3, 1)  # Orange
			"PERCEPTION":
				glyph_display.modulate = Color(0.9, 0.3, 0.9, 1)  # Purple
			"TEMPORAL":
				glyph_display.modulate = Color(0.9, 0.9, 0.3, 1)  # Yellow
			_:
				glyph_display.modulate = Color(1, 1, 1, 1)  # White

## Get the glyph data
func get_glyph_data() -> GlyphDatabase.GlyphData:
	if GlyphDatabase:
		return GlyphDatabase.get_glyph(glyph_id)
	return null
