@tool
extends Control
class_name GlyphDisplay
## Displays a glyph symbol visually

@export var glyph_id: String = "AQUA":
	set(value):
		glyph_id = value
		queue_redraw()

@export var glyph_color: Color = Color(0.9, 0.85, 0.7):
	set(value):
		glyph_color = value
		queue_redraw()

@export var glyph_size: float = 48.0:
	set(value):
		glyph_size = value
		custom_minimum_size = Vector2(glyph_size, glyph_size)
		queue_redraw()

@export var show_background: bool = true
@export var background_color: Color = Color(0.15, 0.12, 0.1, 0.9)

func _ready() -> void:
	custom_minimum_size = Vector2(glyph_size, glyph_size)

func _draw() -> void:
	var center = size / 2
	var draw_size = min(size.x, size.y) * 0.9

	# Background
	if show_background:
		draw_rect(Rect2(Vector2.ZERO, size), background_color)
		# Border
		draw_rect(Rect2(Vector2.ZERO, size), glyph_color * 0.5, false, 2.0)

	# Get glyph paths
	if not GlyphRenderer.GLYPH_PATHS.has(glyph_id):
		# Draw unknown symbol
		_draw_unknown(center, draw_size)
		return

	var paths = GlyphRenderer.GLYPH_PATHS[glyph_id]
	var offset = (size - Vector2(draw_size, draw_size)) / 2

	for cmd in paths:
		match cmd[0]:
			"line":
				var p1 = offset + Vector2(cmd[1], cmd[2]) * draw_size
				var p2 = offset + Vector2(cmd[3], cmd[4]) * draw_size
				draw_line(p1, p2, glyph_color, 2.5, true)
			"circle":
				var pos = offset + Vector2(cmd[1], cmd[2]) * draw_size
				var radius = cmd[3] * draw_size
				draw_arc(pos, radius, 0, TAU, 32, glyph_color, 2.5, true)
			"arc":
				var pos = offset + Vector2(cmd[1], cmd[2]) * draw_size
				var radius = cmd[3] * draw_size
				draw_arc(pos, radius, cmd[4], cmd[5], 24, glyph_color, 2.5, true)
			"bezier":
				_draw_bezier(cmd.slice(1), offset, draw_size)

func _draw_bezier(points: Array, offset: Vector2, scale: float) -> void:
	var curve_points: PackedVector2Array = []
	var steps = 20

	for i in range(steps + 1):
		var t = float(i) / steps
		var x: float
		var y: float

		if points.size() >= 8:
			var t2 = t * t
			var t3 = t2 * t
			var mt = 1 - t
			var mt2 = mt * mt
			var mt3 = mt2 * mt
			x = mt3 * points[0] + 3 * mt2 * t * points[2] + 3 * mt * t2 * points[4] + t3 * points[6]
			y = mt3 * points[1] + 3 * mt2 * t * points[3] + 3 * mt * t2 * points[5] + t3 * points[7]
		else:
			var mt = 1 - t
			x = mt * mt * points[0] + 2 * mt * t * points[2] + t * t * points[4]
			y = mt * mt * points[1] + 2 * mt * t * points[3] + t * t * points[5]

		curve_points.append(offset + Vector2(x, y) * scale)

	if curve_points.size() > 1:
		draw_polyline(curve_points, glyph_color, 2.5, true)

func _draw_unknown(center: Vector2, sz: float) -> void:
	var half = sz * 0.3
	draw_line(center - Vector2(half, half), center + Vector2(half, half), glyph_color, 2.5)
	draw_line(center - Vector2(-half, half), center + Vector2(-half, half), glyph_color, 2.5)
