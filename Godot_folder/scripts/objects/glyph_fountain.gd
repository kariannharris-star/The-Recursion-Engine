extends StaticBody3D
class_name GlyphFountain
## Interactive fountain that reveals a glyph when examined

@export var glyph_symbol: String = "≋"  # Water waves symbol

var has_shown_glyph: bool = false

@onready var glyph_display: Node3D = $GlyphDisplay

func _ready() -> void:
	add_to_group("interactable")
	if glyph_display:
		glyph_display.visible = false

func interact(player) -> void:
	if not has_shown_glyph:
		_reveal_glyph()
	else:
		print("[Fountain] The water shows: %s" % glyph_symbol)

func _reveal_glyph() -> void:
	has_shown_glyph = true

	# Show the glyph display
	if glyph_display:
		glyph_display.visible = true
		_animate_glyph_reveal()

	# Discover the glyph
	if GlyphDatabase:
		GlyphDatabase.discover_glyph(glyph_symbol, "fountain_interaction")

	print("")
	print("═══════════════════════════════════════")
	print("        GLYPH DISCOVERED")
	print("═══════════════════════════════════════")
	print("")
	print("           %s" % glyph_symbol)
	print("")
	print("  The ancient symbol glows in the water...")
	print("")
	print("═══════════════════════════════════════")

func _animate_glyph_reveal() -> void:
	if glyph_display:
		glyph_display.scale = Vector3.ZERO
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(glyph_display, "scale", Vector3.ONE, 0.8)
