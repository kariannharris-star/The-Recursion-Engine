extends Node
class_name GlyphRenderer
## Renders glyphs as procedural symbols using draw commands

# Glyph symbol definitions - each is an array of draw commands
# Commands: ["line", x1, y1, x2, y2], ["circle", x, y, r], ["arc", x, y, r, start, end]
const GLYPH_PATHS := {
	# SUBSTANCE GLYPHS - Flowing, elemental shapes
	"AQUA": [  # Water - three wavy lines
		["bezier", 0.1, 0.3, 0.3, 0.2, 0.5, 0.3, 0.7, 0.2, 0.9, 0.3],
		["bezier", 0.1, 0.5, 0.3, 0.4, 0.5, 0.5, 0.7, 0.4, 0.9, 0.5],
		["bezier", 0.1, 0.7, 0.3, 0.6, 0.5, 0.7, 0.7, 0.6, 0.9, 0.7],
	],
	"PETRA": [  # Stone - angular mountain shape
		["line", 0.5, 0.15, 0.85, 0.85],
		["line", 0.85, 0.85, 0.15, 0.85],
		["line", 0.15, 0.85, 0.5, 0.15],
		["line", 0.35, 0.55, 0.65, 0.55],
	],
	"IGNIS": [  # Fire - flame shape
		["line", 0.5, 0.1, 0.7, 0.5],
		["line", 0.7, 0.5, 0.6, 0.4],
		["line", 0.6, 0.4, 0.75, 0.8],
		["line", 0.75, 0.8, 0.5, 0.6],
		["line", 0.5, 0.6, 0.25, 0.8],
		["line", 0.25, 0.8, 0.4, 0.4],
		["line", 0.4, 0.4, 0.3, 0.5],
		["line", 0.3, 0.5, 0.5, 0.1],
	],
	"GLACIES": [  # Ice - crystalline hexagon
		["line", 0.5, 0.1, 0.8, 0.3],
		["line", 0.8, 0.3, 0.8, 0.7],
		["line", 0.8, 0.7, 0.5, 0.9],
		["line", 0.5, 0.9, 0.2, 0.7],
		["line", 0.2, 0.7, 0.2, 0.3],
		["line", 0.2, 0.3, 0.5, 0.1],
		["line", 0.5, 0.1, 0.5, 0.9],  # Vertical line
		["line", 0.2, 0.5, 0.8, 0.5],  # Horizontal line
	],
	"AETHER": [  # Air - spiral with dots
		["circle", 0.5, 0.5, 0.3],
		["circle", 0.5, 0.2, 0.05],
		["circle", 0.8, 0.5, 0.05],
		["circle", 0.5, 0.8, 0.05],
		["circle", 0.2, 0.5, 0.05],
	],
	"FERRUM": [  # Metal - interlocking gears
		["circle", 0.35, 0.4, 0.2],
		["circle", 0.65, 0.6, 0.2],
		["line", 0.35, 0.2, 0.35, 0.15],
		["line", 0.15, 0.4, 0.1, 0.4],
		["line", 0.65, 0.8, 0.65, 0.85],
		["line", 0.85, 0.6, 0.9, 0.6],
	],

	# STATE GLYPHS - Condition indicators
	"FLOW": [  # Movement - arrow curves
		["line", 0.2, 0.5, 0.8, 0.5],
		["line", 0.6, 0.3, 0.8, 0.5],
		["line", 0.6, 0.7, 0.8, 0.5],
		["bezier", 0.2, 0.3, 0.4, 0.3, 0.4, 0.7, 0.2, 0.7],
	],
	"STASIS": [  # Still - enclosed square
		["line", 0.25, 0.25, 0.75, 0.25],
		["line", 0.75, 0.25, 0.75, 0.75],
		["line", 0.75, 0.75, 0.25, 0.75],
		["line", 0.25, 0.75, 0.25, 0.25],
		["circle", 0.5, 0.5, 0.1],
	],
	"LUMEN": [  # Light - sun rays
		["circle", 0.5, 0.5, 0.15],
		["line", 0.5, 0.15, 0.5, 0.25],
		["line", 0.5, 0.75, 0.5, 0.85],
		["line", 0.15, 0.5, 0.25, 0.5],
		["line", 0.75, 0.5, 0.85, 0.5],
		["line", 0.26, 0.26, 0.35, 0.35],
		["line", 0.74, 0.26, 0.65, 0.35],
		["line", 0.26, 0.74, 0.35, 0.65],
		["line", 0.74, 0.74, 0.65, 0.65],
	],
	"UMBRA": [  # Dark - filled crescent
		["arc", 0.5, 0.5, 0.35, 0.5, 2.5],
		["arc", 0.65, 0.5, 0.25, 2.0, 4.3],
	],
	"MAGNUS": [  # Large - expanding arrows
		["line", 0.5, 0.5, 0.5, 0.15],
		["line", 0.5, 0.5, 0.85, 0.5],
		["line", 0.5, 0.5, 0.5, 0.85],
		["line", 0.5, 0.5, 0.15, 0.5],
		["line", 0.4, 0.25, 0.5, 0.15],
		["line", 0.6, 0.25, 0.5, 0.15],
		["line", 0.75, 0.4, 0.85, 0.5],
		["line", 0.75, 0.6, 0.85, 0.5],
	],
	"PARVUS": [  # Small - contracting arrows
		["line", 0.5, 0.15, 0.5, 0.4],
		["line", 0.5, 0.85, 0.5, 0.6],
		["line", 0.15, 0.5, 0.4, 0.5],
		["line", 0.85, 0.5, 0.6, 0.5],
		["line", 0.4, 0.35, 0.5, 0.4],
		["line", 0.6, 0.35, 0.5, 0.4],
		["circle", 0.5, 0.5, 0.08],
	],

	# ACTION GLYPHS - Directional and transformative
	"ASCENDE": [  # Rise - upward spiral
		["line", 0.5, 0.85, 0.5, 0.15],
		["line", 0.3, 0.35, 0.5, 0.15],
		["line", 0.7, 0.35, 0.5, 0.15],
		["bezier", 0.3, 0.7, 0.2, 0.5, 0.5, 0.5, 0.5, 0.7],
	],
	"DESCENDE": [  # Fall - downward spiral
		["line", 0.5, 0.15, 0.5, 0.85],
		["line", 0.3, 0.65, 0.5, 0.85],
		["line", 0.7, 0.65, 0.5, 0.85],
		["bezier", 0.7, 0.3, 0.8, 0.5, 0.5, 0.5, 0.5, 0.3],
	],
	"ROTARE": [  # Turn - circular arrow
		["arc", 0.5, 0.5, 0.3, 0.0, 5.5],
		["line", 0.75, 0.35, 0.8, 0.5],
		["line", 0.75, 0.35, 0.65, 0.3],
	],
	"APERIRE": [  # Open - parting doors
		["line", 0.3, 0.2, 0.15, 0.5],
		["line", 0.15, 0.5, 0.3, 0.8],
		["line", 0.7, 0.2, 0.85, 0.5],
		["line", 0.85, 0.5, 0.7, 0.8],
		["line", 0.4, 0.4, 0.5, 0.5],
		["line", 0.5, 0.5, 0.4, 0.6],
		["line", 0.6, 0.4, 0.5, 0.5],
		["line", 0.5, 0.5, 0.6, 0.6],
	],
	"CLAUDERE": [  # Close - converging doors
		["line", 0.15, 0.2, 0.3, 0.5],
		["line", 0.3, 0.5, 0.15, 0.8],
		["line", 0.85, 0.2, 0.7, 0.5],
		["line", 0.7, 0.5, 0.85, 0.8],
		["line", 0.4, 0.5, 0.6, 0.5],
	],
	"MUTARE": [  # Change - transformation symbol
		["circle", 0.3, 0.35, 0.15],
		["circle", 0.7, 0.65, 0.15],
		["line", 0.4, 0.45, 0.6, 0.55],
		["line", 0.55, 0.5, 0.6, 0.55],
		["line", 0.55, 0.6, 0.6, 0.55],
	],

	# PERCEPTION GLYPHS
	"VISIO": [  # Sight - eye
		["arc", 0.5, 0.5, 0.3, 0.3, 2.84],
		["arc", 0.5, 0.5, 0.3, 3.44, 6.0],
		["circle", 0.5, 0.5, 0.1],
	],
	"AUDIO": [  # Sound - waves
		["arc", 0.3, 0.5, 0.1, 4.7, 7.85],
		["arc", 0.3, 0.5, 0.2, 4.7, 7.85],
		["arc", 0.3, 0.5, 0.3, 4.7, 7.85],
		["circle", 0.3, 0.5, 0.05],
	],
	"TACTUS": [  # Touch - hand
		["line", 0.5, 0.8, 0.5, 0.4],
		["line", 0.5, 0.4, 0.35, 0.2],
		["line", 0.5, 0.45, 0.45, 0.25],
		["line", 0.5, 0.45, 0.55, 0.25],
		["line", 0.5, 0.4, 0.65, 0.2],
		["line", 0.5, 0.4, 0.7, 0.35],
	],
	"MENSURA": [  # Measure - ruler marks
		["line", 0.2, 0.5, 0.8, 0.5],
		["line", 0.2, 0.35, 0.2, 0.65],
		["line", 0.8, 0.35, 0.8, 0.65],
		["line", 0.35, 0.4, 0.35, 0.6],
		["line", 0.5, 0.35, 0.5, 0.65],
		["line", 0.65, 0.4, 0.65, 0.6],
	],

	# TEMPORAL GLYPHS
	"TEMPUS": [  # Time - hourglass
		["line", 0.25, 0.2, 0.75, 0.2],
		["line", 0.25, 0.8, 0.75, 0.8],
		["line", 0.25, 0.2, 0.5, 0.5],
		["line", 0.75, 0.2, 0.5, 0.5],
		["line", 0.25, 0.8, 0.5, 0.5],
		["line", 0.75, 0.8, 0.5, 0.5],
	],
	"MORA": [  # Delay - pause bars
		["line", 0.35, 0.25, 0.35, 0.75],
		["line", 0.65, 0.25, 0.65, 0.75],
	],
	"CELERITAS": [  # Speed - motion lines
		["line", 0.2, 0.3, 0.8, 0.3],
		["line", 0.3, 0.5, 0.8, 0.5],
		["line", 0.2, 0.7, 0.8, 0.7],
		["line", 0.65, 0.2, 0.8, 0.3],
		["line", 0.65, 0.4, 0.8, 0.3],
	],
}

## Create a texture for a glyph
static func create_glyph_texture(glyph_id: String, size: int = 64, color: Color = Color.WHITE) -> ImageTexture:
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)

	if not GLYPH_PATHS.has(glyph_id):
		# Draw placeholder X
		_draw_line_on_image(image, 0.2, 0.2, 0.8, 0.8, color, size)
		_draw_line_on_image(image, 0.8, 0.2, 0.2, 0.8, color, size)
	else:
		var paths = GLYPH_PATHS[glyph_id]
		for cmd in paths:
			match cmd[0]:
				"line":
					_draw_line_on_image(image, cmd[1], cmd[2], cmd[3], cmd[4], color, size)
				"circle":
					_draw_circle_on_image(image, cmd[1], cmd[2], cmd[3], color, size)
				"arc":
					_draw_arc_on_image(image, cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], color, size)
				"bezier":
					_draw_bezier_on_image(image, cmd.slice(1), color, size)

	var texture = ImageTexture.create_from_image(image)
	return texture

static func _draw_line_on_image(img: Image, x1: float, y1: float, x2: float, y2: float, color: Color, size: int) -> void:
	var px1 = int(x1 * size)
	var py1 = int(y1 * size)
	var px2 = int(x2 * size)
	var py2 = int(y2 * size)

	var dx = abs(px2 - px1)
	var dy = abs(py2 - py1)
	var sx = 1 if px1 < px2 else -1
	var sy = 1 if py1 < py2 else -1
	var err = dx - dy

	while true:
		if px1 >= 0 and px1 < size and py1 >= 0 and py1 < size:
			img.set_pixel(px1, py1, color)
			# Thicken line
			if px1 + 1 < size:
				img.set_pixel(px1 + 1, py1, color)
			if py1 + 1 < size:
				img.set_pixel(px1, py1 + 1, color)

		if px1 == px2 and py1 == py2:
			break
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			px1 += sx
		if e2 < dx:
			err += dx
			py1 += sy

static func _draw_circle_on_image(img: Image, cx: float, cy: float, r: float, color: Color, size: int) -> void:
	var pcx = int(cx * size)
	var pcy = int(cy * size)
	var pr = int(r * size)

	for angle in range(0, 360, 5):
		var rad = deg_to_rad(angle)
		var px = pcx + int(cos(rad) * pr)
		var py = pcy + int(sin(rad) * pr)
		if px >= 0 and px < size and py >= 0 and py < size:
			img.set_pixel(px, py, color)
			if px + 1 < size:
				img.set_pixel(px + 1, py, color)
			if py + 1 < size:
				img.set_pixel(px, py + 1, color)

static func _draw_arc_on_image(img: Image, cx: float, cy: float, r: float, start: float, end: float, color: Color, size: int) -> void:
	var pcx = int(cx * size)
	var pcy = int(cy * size)
	var pr = int(r * size)

	var steps = int((end - start) * 20)
	for i in range(steps):
		var angle = start + (end - start) * i / steps
		var px = pcx + int(cos(angle) * pr)
		var py = pcy + int(sin(angle) * pr)
		if px >= 0 and px < size and py >= 0 and py < size:
			img.set_pixel(px, py, color)
			if px + 1 < size:
				img.set_pixel(px + 1, py, color)

static func _draw_bezier_on_image(img: Image, points: Array, color: Color, size: int) -> void:
	# Simple bezier with control points
	var steps = 30
	for i in range(steps):
		var t = float(i) / steps
		var x: float
		var y: float

		if points.size() >= 8:  # Cubic with 2 control points
			var t2 = t * t
			var t3 = t2 * t
			var mt = 1 - t
			var mt2 = mt * mt
			var mt3 = mt2 * mt
			x = mt3 * points[0] + 3 * mt2 * t * points[2] + 3 * mt * t2 * points[4] + t3 * points[6]
			y = mt3 * points[1] + 3 * mt2 * t * points[3] + 3 * mt * t2 * points[5] + t3 * points[7]
		else:  # Quadratic
			var mt = 1 - t
			x = mt * mt * points[0] + 2 * mt * t * points[2] + t * t * points[4]
			y = mt * mt * points[1] + 2 * mt * t * points[3] + t * t * points[5]

		var px = int(x * size)
		var py = int(y * size)
		if px >= 0 and px < size and py >= 0 and py < size:
			img.set_pixel(px, py, color)
			if px + 1 < size:
				img.set_pixel(px + 1, py, color)
