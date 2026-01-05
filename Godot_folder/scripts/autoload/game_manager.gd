extends Node
## Game Manager - Global game state singleton
## Handles game state, room transitions, and core game logic

# =============================================================================
# ENUMS
# =============================================================================

## The three scale states the player can be in
enum Scale { NORMAL, MICRO, MACRO }

## Current game state
enum GameState { PLAYING, PAUSED, IN_MENU, IN_NOTEBOOK, IN_PUZZLE, IN_QUIZ }

# =============================================================================
# SIGNALS
# =============================================================================

## Emitted when player changes scale
signal scale_changed(new_scale: Scale)

## Emitted when entering a new room
signal room_changed(room_id: String)

## Emitted when game state changes
signal game_state_changed(new_state: GameState)

## Emitted when a glyph is discovered
signal glyph_discovered(glyph_id: String)

## Emitted when player interacts with something
signal interaction_triggered(target: Node)

# =============================================================================
# GAME STATE
# =============================================================================

## Current player scale (Normal, Micro, or Macro)
var current_scale: Scale = Scale.NORMAL

## Current game state
var current_state: GameState = GameState.PLAYING

## Current room ID
var current_room: String = "room_1_1"

## Total playtime in seconds
var total_playtime: float = 0.0

## Is the game currently transitioning between rooms?
var is_transitioning: bool = false

# =============================================================================
# SCALE CONSTANTS
# =============================================================================

## Visual scale multipliers for each scale state
const SCALE_MULTIPLIERS := {
	Scale.NORMAL: 1.0,
	Scale.MICRO: 0.25,   # Player appears 1/4 size
	Scale.MACRO: 4.0     # Player appears 4x size
}

## Movement speed remains constant, but feels different at each scale
const BASE_MOVE_SPEED := 200.0  # pixels per second

# =============================================================================
# LIFECYCLE
# =============================================================================

func _ready() -> void:
	# Ensure this persists across scene changes
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("[GameManager] Initialized")

func _process(delta: float) -> void:
	# Track playtime when playing
	if current_state == GameState.PLAYING:
		total_playtime += delta

# =============================================================================
# SCALE MANAGEMENT
# =============================================================================

## Change the player's scale state
func set_scale(new_scale: Scale) -> void:
	if new_scale == current_scale:
		return

	var old_scale = current_scale
	current_scale = new_scale
	print("[GameManager] Scale changed: %s -> %s" % [Scale.keys()[old_scale], Scale.keys()[new_scale]])
	scale_changed.emit(new_scale)

## Cycle to the next scale (Normal -> Micro -> Normal -> Macro -> Normal)
## Returns true if scale change was successful
func cycle_scale(allow_micro: bool = true, allow_macro: bool = true) -> bool:
	match current_scale:
		Scale.NORMAL:
			# From Normal, try Micro first, then Macro
			if allow_micro:
				set_scale(Scale.MICRO)
				return true
			elif allow_macro:
				set_scale(Scale.MACRO)
				return true
		Scale.MICRO:
			# From Micro, always go back to Normal
			set_scale(Scale.NORMAL)
			return true
		Scale.MACRO:
			# From Macro, always go back to Normal
			set_scale(Scale.NORMAL)
			return true
	return false

## Get the visual scale multiplier for current scale
func get_scale_multiplier() -> float:
	return SCALE_MULTIPLIERS[current_scale]

## Check if player can shift to a specific scale
func can_shift_to(target_scale: Scale, room_allows_micro: bool = true, room_allows_macro: bool = true) -> bool:
	match target_scale:
		Scale.MICRO:
			return room_allows_micro
		Scale.MACRO:
			return room_allows_macro
		Scale.NORMAL:
			return true  # Can always return to normal
	return false

# =============================================================================
# GAME STATE MANAGEMENT
# =============================================================================

## Change the current game state
func set_game_state(new_state: GameState) -> void:
	if new_state == current_state:
		return

	var old_state = current_state
	current_state = new_state
	print("[GameManager] State changed: %s -> %s" % [GameState.keys()[old_state], GameState.keys()[new_state]])
	game_state_changed.emit(new_state)

## Check if game is in a playable state (not paused or in menu)
func is_playing() -> bool:
	return current_state == GameState.PLAYING

## Pause the game
func pause_game() -> void:
	set_game_state(GameState.PAUSED)
	get_tree().paused = true

## Resume the game
func resume_game() -> void:
	get_tree().paused = false
	set_game_state(GameState.PLAYING)

# =============================================================================
# ROOM MANAGEMENT
# =============================================================================

## Change to a new room
func change_room(room_id: String, spawn_point: String = "default") -> void:
	if is_transitioning:
		return

	is_transitioning = true
	current_room = room_id
	print("[GameManager] Changing to room: %s (spawn: %s)" % [room_id, spawn_point])

	# Load the new room scene
	var room_path = "res://scenes/rooms/%s.tscn" % room_id

	# Use call_deferred to safely change scenes
	call_deferred("_load_room", room_path, spawn_point)

func _load_room(room_path: String, spawn_point: String) -> void:
	var error = get_tree().change_scene_to_file(room_path)
	if error != OK:
		push_error("[GameManager] Failed to load room: %s" % room_path)

	is_transitioning = false
	room_changed.emit(current_room)

# =============================================================================
# UTILITY
# =============================================================================

## Format playtime as HH:MM:SS
func get_formatted_playtime() -> String:
	var hours = int(total_playtime / 3600)
	var minutes = int(fmod(total_playtime, 3600) / 60)
	var seconds = int(fmod(total_playtime, 60))
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

## Get scale name as string
func get_scale_name() -> String:
	return Scale.keys()[current_scale]
