# **The Recursion Engine - Product Requirements Document (PRD)**

---

## **1. EXECUTIVE SUMMARY**

**Title:** The Recursion Engine  
**Genre:** 2D Top-Down Puzzle Adventure  
**Target Platform:** Steam (PC)  
**Visual Style:** Link's Awakening-inspired 2D with depth  
**Core Hook:** Learn an ancient language through exploration, manipulate reality across multiple scales, solve intricate puzzles  
**Target Playtime:** 12-15 hours for main story, 18-20 hours for 100% completion  
**Target Audience:** Puzzle enthusiasts, fans of Chants of Sennaar, The Witness, environmental storytelling

---

## **2. GAME OVERVIEW**

### **2.1 High Concept**
You awaken in an ancient machine-temple that exists simultaneously at multiple scales of reality. By learning the temple's symbolic language and solving puzzles by shifting between macro, normal, and micro scales, you must power up the mysterious Engine and discover its true purpose.

### **2.2 Core Pillars**
1. **Language Discovery** - Learn glyphs through pure observation and context
2. **Scale Manipulation** - Navigate and solve puzzles at different sizes
3. **Environmental Puzzles** - Understand the world to progress
4. **Environmental Storytelling** - Uncover lore through murals, inscriptions, architecture
5. **Earned Progression** - Quiz gates ensure genuine understanding

---

## **3. CORE MECHANICS**

### **3.1 Movement & Controls**
- **WASD/Arrow Keys** - 8-directional movement
- **E/Space** - Interact with objects, pedestals, control panels
- **Q** - Open notebook
- **Shift** - Toggle scale (when at scale pedestal)
- **Tab** - Quick-reference glyph glossary
- **Mouse** - Drag glyphs in puzzle panels and quizzes

### **3.2 Scale-Shifting System**

**Three Scale States:**

**Normal Scale (Default)**
- Standard room view (16x12 tile viewport)
- Most exploration happens here
- Can interact with normal-sized objects
- Standard movement speed: 4 tiles/second

**Micro Scale (Player shrinks)**
- Camera stays same size, but player is now tiny (1/4 visual size)
- Room layout unchanged, but perspective shifts
- Can walk through cracks in walls (marked with subtle visual cues)
- Can fall through grates/holes in floor to access lower areas
- Puddles become swimmable bodies of water
- Pebbles become boulders (obstacles)
- Dust particles visible and interactable
- Small inscriptions become readable
- Movement speed unchanged (4 tiles/second) but feels faster relative to environment
- **Cannot macro-shift from micro** - must return to normal first

**Macro Scale (Player grows)**
- Camera stays same size, player becomes large (4x visual size)
- Room feels cramped - **walls prevent shifting if room too small**
- Boulders become pebbles (can push)
- Large gaps become steppable
- Can reach high ledges
- Cannot fit through normal doorways (must use large archways)
- Movement speed unchanged but feels slower
- **Restricted in confined spaces** - "The walls are too close to grow larger"

**Scale Pedestal Mechanic:**
- Glowing pedestals throughout dungeons
- Step on pedestal, press Shift to cycle: Normal → Micro → Normal → Macro → Normal
- Cannot skip scales (must cycle through)
- Visual feedback: Player glows, brief particle effect, smooth size transition (0.3s)
- Some pedestals only allow certain scale shifts until glyphs learned
- Pedestal glyphs indicate which scales are available

**Scale Restrictions (Critical for Puzzle Design):**
- **Thin-walled rooms**: "You cannot grow larger here - the walls are too close"
- **Floored areas**: "There are no gaps to shrink into here" (prevents micro in some rooms)
- **Scale-locked doors**: Require specific scale to pass through
  - Micro doors: Cracks in walls
  - Normal doors: Standard archways
  - Macro doors: Grand archways
- Player must plan scale shifts strategically

### **3.3 Glyph Language System**

**Glyph Philosophy:**
Glyphs are **descriptive labels** for understanding the world, NOT powers or abilities. They describe what objects do, what mechanisms require, or what states exist. You read glyphs to understand how to interact with the environment.

**Example - Water Channel:**
```
Control Panel: [AQUA] + [FLOW] + [DESCENDE]

This describes: "Water flows downward"
Player action: Activate mechanism → water drains
This is not casting a spell, it's reading instructions
```

**Glyph Design Principles:**
- Abstract symbolic designs (no literal pictographs)
- Combination of geometric shapes and flowing lines
- Inspired by: alchemical symbols, cuneiform, ancient seals
- Each glyph visually distinct even at small sizes
- Cultural consistency (all glyphs feel like same language family)

**Glyph Categories:**

**SUBSTANCE GLYPHS (What things are made of)**
- **AQUA** - Water/liquid (flowing curved lines)
- **PETRA** - Stone/solid/earth (angular, stable base)
- **IGNIS** - Fire/heat/light (radiating points)
- **GLACIES** - Ice/frozen/cold (sharp crystalline angles)
- **AETHER** - Air/void/space (open circles, dots)
- **FERRUM** - Metal/mechanism (interlocking geometric shapes)

**STATE GLYPHS (Conditions and qualities)**
- **FLOW** - Movement/flowing/active (directional curves)
- **STASIS** - Still/stopped/inactive (enclosed shape)
- **LUMEN** - Bright/illuminated/visible (radiating lines)
- **UMBRA** - Dark/hidden/obscured (filled solid)
- **MAGNUS** - Large/great/expanded (outward-pointing angles)
- **PARVUS** - Small/tiny/reduced (inward-pointing angles)

**ACTION GLYPHS (What happens)**
- **ASCENDE** - Rising/upward/increase (upward-flowing spiral)
- **DESCENDE** - Falling/downward/decrease (downward-flowing spiral)
- **ROTARE** - Turning/rotating/cycling (circular with center point)
- **APERIRE** - Opening/revealing/unlocking (parting lines)
- **CLAUDERE** - Closing/sealing/locking (converging lines)
- **MUTARE** - Changing/transforming/becoming (overlapping shapes)

**PERCEPTION GLYPHS (Understanding)**
- **VISIO** - Sight/seeing/observation (eye-like symbol)
- **AUDIO** - Sound/hearing/echo (wave patterns)
- **TACTUS** - Touch/physical/solid (hand-like symbol)
- **MENSURA** - Measurement/scale/proportion (ruler-like marks)

**TEMPORAL GLYPHS (Time-related)**
- **TEMPUS** - Time/duration/passage (cyclical with gap)
- **MORA** - Delay/waiting/pause (stacked horizontal lines)
- **CELERITAS** - Speed/rapid/immediate (compressed spiral)

**LOGIC GLYPHS (Grammar/Modifiers)**
- **Circle (○)** - Continuous/always/eternal (glyph inside circle)
- **Triangle (△)** - Conditional/if/when (glyph inside triangle)
- **Line-through (⌀)** - Negation/not/opposite (line through glyph)
- **Double-border** - Emphasis/strong/required (double outline)

**Total Core Glyphs: 25 base + 4 modifiers = 29 symbols**

### **3.4 Glyph Learning Process**

**Discovery Phase:**
1. Player enters new room
2. Sees glyph carved on wall/object
3. Notebook auto-adds entry with sketch
4. Status: "Unknown - meaning unclear"

**Context Gathering:**
- See AQUA near fountains, pools, water channels
- See AQUA in murals depicting rain, rivers
- Hear echo-stones say "ah-kwa" near AQUA symbol
- Find tablets pairing AQUA with later script that says "water"

**Hypothesis Phase:**
- Player opens notebook
- Types their guess: "Water" or "Liquid" or "Flow"
- Notebook tracks where each glyph was found
- No validation yet

**Validation Phase:**
- Reach quiz gate
- Drag glyphs to match meanings (images or words)
- Correct matches confirm meanings
- Incorrect attempts provide score only (until attempt 10+)

**Application Phase:**
- Use confirmed glyphs in control panels
- Understand mechanism instructions
- Combine glyphs to solve puzzles

### **3.5 Control Panel Mechanics**

**How Panels Work:**
Control panels are found throughout dungeons. They don't grant powers - they're **instructions for mechanisms** or **locks requiring specific knowledge**.

**Panel Types:**

**Type 1: Instruction Panels (Read-only)**
```
╔════════════════════╗
║  [AQUA] + [FLOW]  ║
║  + [DESCENDE]     ║
╚════════════════════╝
```
Translation: "Water flows downward"
Purpose: Tells you what this mechanism does
Player Action: Understand, then manipulate the mechanism manually

**Type 2: Input Panels (Interactive)**
```
╔════════════════════╗
║  [ ? ] + [ ? ]    ║
║                   ║
║  [Submit]         ║
╚════════════════════╝
```
Purpose: Lock that requires correct glyph sequence
Player Action: Drag correct glyphs from inventory to slots
Correct sequence → door unlocks, mechanism activates
Incorrect sequence → nothing happens, or minor feedback (light flickers)

**Type 3: Compound Panels (Late game)**
```
╔════════════════════╗
║  [ ? ] + [ ? ]    ║
║      ↓             ║
║  [ ? ] + [ ? ]    ║
║      ↓             ║
║  [THEN: ? ]       ║
╚════════════════════╝
```
Purpose: Multi-step sequences
Translation example: "Stone becomes ice, then ice flows down"
Player Action: Fill in sequence correctly

**Panel Interaction:**
- Click panel to open interface
- Known glyphs appear at bottom as draggable icons
- Drag glyph to empty slot
- Click glyph in slot to remove it
- Submit when all slots filled
- Visual/audio feedback on success/failure

---

## **4. DUNGEON STRUCTURE**

### **4.1 Overall Progression**

**7 Major Dungeons** (Temple Wings)
- Each teaches 3-5 new glyphs
- Each introduces new scale-based puzzle mechanics
- Progressive difficulty in glyph compounds
- Quiz gate between each dungeon

**Estimated Completion Times:**
- Dungeon 1: 60-90 minutes (tutorial)
- Dungeons 2-3: 90-120 minutes each
- Dungeons 4-5: 120-150 minutes each
- Dungeon 6: 150-180 minutes
- Dungeon 7: 180-240 minutes (final challenges)

### **4.2 Dungeon 1: The Hydraulic Gardens**

**Theme:** Water, basic scale shifting, introduction to language  
**New Glyphs:** AQUA, PETRA, FLOW, STASIS, APERIRE  
**Room Count:** 12 rooms + Boss Chamber + Quiz Gate

**Learning Objectives:**
- Understand scale-shifting basics
- Learn first 5 glyphs through context
- Practice using control panels
- Understand that glyphs are descriptive, not powers

**Room Breakdown:**

**Room 1-1: Awakening Chamber (Entrance)**
- Player wakes on a platform
- Single exit north
- AQUA glyph carved above a dry fountain (inactive)
- Tutorial: Movement controls
- Simple push-block to reach door

**Room 1-2: The First Pedestal**
- Scale Pedestal in center (glowing, inviting)
- Tutorial pop-up: "Step on the pedestal and press [Shift]"
- Small crack in east wall (too small to fit through)
- Practice: Shift to Micro → walk through crack → find AQUA inscription → shift back to Normal at second pedestal
- Door unlocks

**Room 1-3: The Fountain Courtyard**
- Large central fountain (active, water flowing)
- AQUA glyph carved prominently on fountain base
- Mural on north wall: figures carrying water vessels, AQUA symbol repeated
- FLOW glyph carved on water channels
- Notebook: "New glyphs discovered" (auto-adds AQUA and FLOW)
- No puzzle, just observation
- Multiple exits (exploration choice)

**Room 1-4: The Stone Garden**
- Boulder blocking path
- PETRA glyph carved on boulder
- Pedestal nearby
- Puzzle: Shift to Macro → boulder becomes pebble → push it aside → return to Normal
- Learn PETRA through context (carved on stone)

**Room 1-5: The Reading Room**
- Ancient tablet on pedestal
- Shows three scripts side-by-side:
  - Ancient glyphs: [AQUA]
  - Middle script: "ah-kwa"
  - Recent script: "water"
- Similar tablets for PETRA ("rock") and FLOW ("movement")
- No puzzle, pure learning moment
- Echo-stone nearby plays "ah-kwa" when touched

**Room 1-6: The Narrow Passage**
- Long hallway
- Too thin for Macro shift
- Message appears if trying: "You cannot grow larger here - the walls are too close"
- Forces Normal/Micro navigation
- Teaches scale restrictions

**Room 1-7: The Drain Puzzle**
- Room with raised water level (flooded)
- Exit door visible but underwater
- Control panel on west wall: [AQUA] + [FLOW] + [ ? ]
- DESCENDE glyph carved on drainage grate
- Solution: Input [AQUA] + [FLOW] + [DESCENDE] → water drains → access door
- **First active use of glyphs**

**Room 1-8: The Grated Floor**
- Floor has large grate holes
- At Normal scale: Cannot pass through
- PARVUS glyph carved near pedestal
- Solution: Shift to Micro → fall through grate to lower level → find key → return via stairs → shift back to Normal → unlock door

**Room 1-9: The Still Pool**
- Pool of water (still, not flowing)
- STASIS glyph carved on basin
- Mural shows water frozen in time
- Control panel: [AQUA] + [STASIS]
- Solution: Activate panel → water becomes solid/ice → walk across → reach door

**Room 1-10: The Opening Gate**
- Large door with APERIRE glyph carved on it
- Control panel: [ ? ]
- Solution: Input [APERIRE] → door opens
- Simple validation of learned glyph

**Room 1-11: The Preparation Chamber**
- Review room before boss
- All 5 glyphs displayed on walls with context images
- Optional: Review tablets, murals
- Save pedestal (checkpoint system)
- Door to boss chamber

**BOSS CHAMBER: The Grand Cistern**
```
╔═════════════════════════════════════╗
║                                     ║
║    🌊🌊🌊 Reservoir (dry)           ║
║    Control Panel A: [?]+[?]+[?]    ║
║                                     ║
║         ⚙️ Gear Mechanism          ║
║         (locked)                    ║
║                                     ║
║    💧 Small puddle                  ║
║    Control Panel B: [?]+[?]        ║
║                                     ║
║         🚪 Exit (locked)            ║
║                                     ║
║    Scale Pedestal (center)          ║
╚═════════════════════════════════════╝
```

**Boss Puzzle Solution:**
1. Examine Panel A: [AQUA] + [FLOW] + [ASCENDE]
   - Translation: "Water flows upward"
2. Activate Panel A → water begins filling reservoir from bottom
3. Shift to Micro scale
4. The small puddle is now a swimmable lake
5. Swim across puddle to reach Panel B (inaccessible at Normal scale)
6. Panel B: [PETRA] + [APERIRE]
   - Translation: "Stone opens"
7. Activate Panel B → stone lock on gear mechanism opens
8. Shift back to Normal
9. Water has risen, creating new paths
10. Push gear mechanism (now accessible)
11. Gear turns → exit door unlocks
12. Success! Dungeon 1 complete

**QUIZ GATE 1:**
```
╔═══════════════════════════════════════════════╗
║  TRANSLATION CHAMBER                          ║
║  Match the glyphs to their meanings:          ║
║                                               ║
║  ┌─────────────┐  ┌─────────────┐           ║
║  │ "Water"     │  │ "Stone"     │           ║
║  │ [Drop here] │  │ [Drop here] │           ║
║  └─────────────┘  └─────────────┘           ║
║                                               ║
║  ┌─────────────┐  ┌─────────────┐           ║
║  │ "Movement"  │  │ "Still"     │           ║
║  │ [Drop here] │  │ [Drop here] │           ║
║  └─────────────┘  └─────────────┘           ║
║                                               ║
║  ┌─────────────┐                             ║
║  │ "Open"      │                             ║
║  │ [Drop here] │                             ║
║  └─────────────┘                             ║
║                                               ║
║  Available: AQUA, PETRA, FLOW,               ║
║             STASIS, APERIRE                   ║
║                                               ║
║  [Submit Answer]                              ║
╚═══════════════════════════════════════════════╝
```

**Pass Requirement:** 5/5 (100%)  
**Feedback:** Attempts 1-9 show score only, Attempt 10+ shows which are wrong  
**Reward:** Access to Dungeon 2

---

### **4.3 Dungeon 2: The Clockwork Halls**

**Theme:** Time, mechanisms, rotation  
**New Glyphs:** TEMPUS, ROTARE, FERRUM, CELERITAS, CLAUDERE  
**Room Count:** 14 rooms + Boss Chamber + Quiz Gate

**Learning Objectives:**
- Understand temporal sequences
- Learn timed puzzles
- Introduce rotation mechanics
- Complex scale interactions with machinery

**Key Puzzle Concepts:**

**Timed Water Rise:**
- Panel: [AQUA] + [TEMPUS] + [ASCENDE]
- Translation: "Water rises over time"
- Mechanism activates, water slowly fills room over 30 seconds
- Must navigate to exit before drowning
- Scale shifting changes water depth perception

**Gear Rotation:**
- ROTARE + FERRUM = "Metal turns"
- Large gears visible at Normal scale
- Shift to Macro → gears become small, can push to start rotation
- Shift to Micro → ride on gear teeth to reach high platforms

**Speed Mechanics:**
- CELERITAS + FLOW = "Fast movement"
- Water rushes through channels quickly
- Must time scale shifts to avoid being swept away

**Closing Doors:**
- CLAUDERE carved on timed doors
- Door closes after mechanism triggered
- Must reach exit before door seals

**Boss Puzzle: The Central Clockwork**
- Multi-stage puzzle requiring:
  1. Shift to Macro → wind the main spring
  2. Input [TEMPUS] + [ROTARE] → clock mechanism starts
  3. Shift to Micro → enter clock mechanism interior
  4. Navigate through turning gears
  5. Pull lever inside
  6. Shift to Normal → observe result
  7. Final panel: [FERRUM] + [APERIRE] → metal lock opens

**Quiz Gate 2:** 10 glyphs total (5 new + 5 from Dungeon 1)

---

### **4.4 Dungeon 3: The Prismatic Sanctum**

**Theme:** Light, vision, perception  
**New Glyphs:** LUMEN, UMBRA, VISIO, MENSURA, MUTARE  
**Room Count:** 15 rooms + Boss Chamber + Quiz Gate

**Learning Objectives:**
- Light-based puzzles
- Scale affects visibility
- Perspective/measurement puzzles
- Transformation concepts

**Key Puzzle Concepts:**

**Light and Shadow:**
- At Micro scale: Dust particles block light beams
- At Macro scale: Small light sources become tiny dots
- LUMEN + VISIO = "Light reveals"
- Shine light on hidden inscriptions to read them

**Measurement Puzzles:**
- MENSURA + MAGNUS/PARVUS = "Measure size"
- Must match sizes of objects across scales
- Example: Three pedestals need objects of equal height
  - At Normal: Find 3 different-sized items
  - At different scales: Adjust perception so they appear equal
  - When all "measured equal," door opens

**Transformation:**
- MUTARE introduces change concept
- [AQUA] + [MUTARE] + [GLACIES] = "Water becomes ice"
- Environmental changes through understanding

**Visibility Restrictions:**
- Some rooms too dark to navigate at Micro (everything appears black)
- Must use Normal/Macro scales
- UMBRA carved in dark zones

**Boss Puzzle: The Lens Array**
- Series of rotating mirrors and lenses
- Must align light path across all three scales
- Macro: Adjust large mirror angles
- Normal: Walk the light beam path to verify
- Micro: Navigate through lens internals to fine-tune

**Quiz Gate 3:** 15 glyphs total

---

### **4.5 Dungeon 4: The Thermal Forge**

**Theme:** Fire, ice, temperature manipulation  
**New Glyphs:** IGNIS, GLACIES, AETHER  
**Room Count:** 16 rooms + Boss Chamber + Quiz Gate

**Learning Objectives:**
- Elemental interactions
- Temperature-based state changes
- Wind/air mechanics at different scales

**Key Puzzle Concepts:**

**Fire and Ice:**
- IGNIS + AQUA = Steam (creates updrafts at Micro scale)
- GLACIES + AQUA = Ice platforms (walk across frozen water)
- IGNIS + GLACIES = Melt (remove ice obstacles)

**Air Currents:**
- AETHER + FLOW = Wind
- At Micro scale: Wind becomes hurricane-force, pushes player
- At Macro scale: Wind barely noticeable
- Must navigate wind tunnels at appropriate scale

**Temperature Zones:**
- Hot zones (IGNIS marked): Ice melts automatically
- Cold zones (GLACIES marked): Water freezes automatically
- Must transport water/ice through appropriate zones

**Boss Puzzle: The Forge Core**
- Central forge with three elemental chambers
- Must create specific temperature conditions in sequence
- Use scale shifting to access valves at different sizes
- Final panel requires all three elements in correct order

**Quiz Gate 4:** 18 glyphs total

---

### **4.6 Dungeon 5: The Recursion Chambers**

**Theme:** Logic, grammar, compound sequences  
**New Glyphs:** Grammar modifiers (○, △, ⌀, double-border)  
**Room Count:** 18 rooms + Boss Chamber + Quiz Gate

**Learning Objectives:**
- Understand glyph grammar
- Create complex compound phrases
- Conditional logic
- Negation and emphasis

**Key Puzzle Concepts:**

**Continuous Actions:**
- [AQUA] inside ○ = "Water flows eternally"
- Mechanism runs continuously until stopped
- Must time navigation around constant hazards

**Conditional Logic:**
- [TEMPUS] inside △ + [ROTARE] = "When time passes, then turn"
- Mechanism only activates after delay
- Player must predict outcomes

**Negation:**
- [FLOW] with ⌀ = "No movement" or "Stopped"
- Stops active mechanisms
- Removes hazards temporarily

**Emphasis:**
- Double-border glyphs = Required/critical
- Missing emphasized glyph causes failure
- Must pay attention to visual distinctions

**Complex Sequences:**
- Multi-panel puzzles with 5-6 glyph combinations
- Example: [AQUA] inside ○ + [ASCENDE] + [TEMPUS] inside △ + [CLAUDERE]
- Translation: "Water continuously rises, when time passes, then close"
- Player must understand full sequence to predict outcome

**Boss Puzzle: The Recursion Engine (Mini)**
- Three interconnected chambers
- Actions in one chamber affect others
- Must program sequences in all three chambers
- Chambers execute in parallel
- Understanding recursion/feedback loops required

**Quiz Gate 5:** 22 glyphs + 4 modifiers = 26 symbols total

---

### **4.7 Dungeon 6: The Resonance Archives**

**Theme:** Sound, memory, echo-location  
**New Glyphs:** AUDIO, TACTUS  
**Room Count:** 17 rooms + Boss Chamber + Quiz Gate

**Learning Objectives:**
- Audio-based puzzles
- Echo-location at different scales
- Touch/physical interaction understanding
- Combining all previous knowledge

**Key Puzzle Concepts:**

**Sound at Different Scales:**
- At Micro: All sounds amplified (footsteps are thunder)
- At Macro: Sounds muffled (bells become faint)
- Must listen for audio cues at correct scale

**Echo-stones (Advanced):**
- Echo-stones that play glyph pronunciations
- Some only audible at certain scales
- Must collect audio clues across scales to decode inscriptions

**Touch Mechanisms:**
- TACTUS + PETRA = "Touch stone"
- Pressure plates require specific weight
- At Micro: Player too light to activate
- At Macro: Player heavy enough to press plates

**Memory Puzzles:**
- Murals that show historical events
- Must understand timeline through glyph sequences
- Reconstruct past events to solve present puzzles

**Boss Puzzle: The Echo Chamber**
- Circular room with sound-reflecting walls
- Must create specific echo patterns
- Use scale shifting to change sound propagation
- Final sequence requires perfect understanding of AUDIO combinations

**Quiz Gate 6:** 27 glyphs + modifiers

---

### **4.8 Dungeon 7: The Engine Heart (Final Dungeon)**

**Theme:** All mechanics combined, final revelations  
**No New Glyphs** - mastery of all 27 glyphs + modifiers  
**Room Count:** 25 rooms + Multiple Boss Chambers + Final Choice Room

**Learning Objectives:**
- Master all glyphs and grammar
- Solve most complex puzzles
- Understand the Engine's true purpose
- Make final choice

**Key Puzzle Concepts:**

**All Mechanics Combined:**
- Puzzles requiring water, fire, ice, light, sound, time
- Multi-scale navigation required for single puzzle
- 7-8 glyph compound sequences
- Environmental storytelling reveals full lore

**The Truth Revealed:**
- Through inscriptions and murals, learn:
  - The ancient civilization's purpose
  - Why the Engine was built
  - What it does
  - What happens if activated

**Multiple Chambers:**
- Chamber of Origins (lore)
- Chamber of Consequences (puzzles showing Engine's power)
- Chamber of Decision (final choice)

**Boss Puzzle: The Engine Core Activation**
- Must navigate entire dungeon to collect 7 "key glyphs"
- Each key glyph is a complex puzzle solution
- Return to core with all keys
- Final panel has 10 glyph slots
- Multiple valid sequences lead to different endings

**Final Choice:**
```
╔═══════════════════════════════════════════════╗
║  THE ENGINE AWAITS YOUR COMMAND               ║
║                                               ║
║  Enter the sequence to determine its fate:    ║
║                                               ║
║  [ ? ] + [ ? ] + [ ? ] + [ ? ] + [ ? ]       ║
║  [ ? ] + [ ? ] + [ ? ] + [ ? ] + [ ? ]       ║
║                                               ║
║  Available: All 27 glyphs + modifiers         ║
║                                               ║
║  Choose wisely. This cannot be undone.        ║
║                                               ║
║  [Submit Sequence]                            ║
╚═══════════════════════════════════════════════╝
```

**Possible Endings (Based on Sequence):**

**Ending 1: Activation**
- Sequence emphasizes TEMPUS + ROTARE + ○ (continuous cycle)
- Engine activates, begins its purpose
- Reveals what the civilization intended

**Ending 2: Shutdown**
- Sequence emphasizes CLAUDERE + STASIS + ⌀ (closed, still, negated)
- Engine powers down permanently
- Temple becomes dormant monument

**Ending 3: Transformation**
- Sequence emphasizes MUTARE + MENSURA + VISIO (change, scale, vision)
- Engine's purpose is altered
- New use for ancient power

**Ending 4: Understanding**
- Sequence emphasizes COGITO + LUMEN + APERIRE (knowledge, light, opening)
- Engine becomes a teacher rather than tool
- Knowledge preserved for future generations

**Final Quiz:** None - player has proven mastery through completion

---

## **5. STEAM TUTORIAL/INTRO BUILD**

### **5.1 Tutorial Scope**

**What to Include in Tutorial Build:**
- Rooms 1-1 through 1-7 from Dungeon 1
- First 5 glyphs: AQUA, PETRA, FLOW, STASIS, APERIRE
- Basic scale-shifting mechanics
- Notebook system introduction
- First quiz gate (simplified to 3 glyphs instead of 5)
- Ends with "Full game coming soon" screen

**Tutorial Flow:**
1. Awakening Chamber (Room 1-1) - Movement
2. First Pedestal (Room 1-2) - Scale shifting introduction
3. Fountain Courtyard (Room 1-3) - Glyph discovery
4. Stone Garden (Room 1-4) - Macro scale puzzle
5. Reading Room (Room 1-5) - Language learning
6. Narrow Passage (Room 1-6) - Scale restrictions
7. Drain Puzzle (Room 1-7) - First active glyph use
8. Simplified Quiz Gate
9. "To be continued" end screen with Steam wishlist link

**Tutorial Success Criteria:**
- Players understand movement
- Players understand scale-shifting
- Players understand glyphs are learned through observation
- Players successfully solve at least one puzzle using glyphs
- Players experience quiz gate system
- Players excited for full game

### **5.2 Technical Implementation for Tutorial**

**Engine:** Godot 4.x (recommended for 2D, open-source, good Steam integration)

**Core Systems to Build:**
1. **Player Controller**
   - 8-directional movement
   - Interaction system
   - Scale state management

2. **Scale System**
   - Pedestal detection
   - Scale transition animations
   - Camera behavior (stays fixed, player size changes)
   - Collision adjustments per scale

3. **Glyph System**
   - Glyph database
   - Discovery tracking
   - Notebook UI
   - Hypothesis input

4. **Control Panel System**
   - Panel interaction UI
   - Glyph drag-and-drop
   - Sequence validation
   - Mechanism triggering

5. **Quiz Gate System**
   - Match-the-meaning UI
   - Glyph-to-definition matching
   - Attempt tracking
   - Score display
   - Feedback at attempt 10+

6. **Save System**
   - Glyph discovery state
   - Room progress
   - Player position
   - Notebook entries

**Asset Requirements:**
- Player sprite (4 frames per direction minimum)
- Tileset for temple architecture
- Glyph symbols (27 + modifiers, multiple sizes)
- UI elements (panels, notebook, quiz interface)
- Water animation tiles
- Object sprites (boulders, pedestals, doors, etc.)

---

## **6. PUZZLE DESIGN PRINCIPLES**

### **6.1 Core Puzzle Philosophy**

**Every Puzzle Must:**
1. Have a clear visual language (glyphs provide context)
2. Be solvable through observation alone
3. Teach one concept well before combining
4. Respect player intelligence (no hand-holding)
5. Provide "aha!" moment satisfaction

**Puzzle Difficulty Curve:**
- **Dungeon 1:** Single-mechanic puzzles (water drains, push blocks)
- **Dungeon 2:** Two-mechanic combinations (water + time, rotation + scale)
- **Dungeon 3:** Three-mechanic puzzles (light + scale + vision)
- **Dungeon 4:** Elemental interactions (fire + ice + water)
- **Dungeon 5:** Logic and grammar (conditionals, negation, emphasis)
- **Dungeon 6:** Sensory puzzles (sound + touch + vision)
- **Dungeon 7:** Everything combined (7-8 mechanic mega-puzzles)

### **6.2 Scale-Based Puzzle Types**

**Type 1: Obstacle Manipulation**
- Macro: Heavy objects become pushable
- Micro: Small gaps become passable
- Example: Boulder blocks path → Macro scale → push boulder → return to Normal

**Type 2: Perception Puzzles**
- Different scales reveal different information
- Example: Inscription too small at Normal → Micro to read details

**Type 3: Multi-Scale Sequences**
- Must perform actions at different scales in order
- Example: Turn valve at Macro → Water flows → Swim through at Micro → Pull lever at Normal

**Type 4: Scale-Locked Access**
- Doors/passages only accessible at specific scales
- Example: Crack in wall (Micro only), grand archway (Macro only)

**Type 5: Relative Size Puzzles**
- Objects change relationship based on scale
- Example: At Micro, pebble is boulder (obstacle). At Macro, boulder is pebble (moveable)

### **6.3 Glyph-Based Puzzle Types**

**Type 1: Direct Translation**
- Panel shows instruction: [AQUA] + [DESCENDE]
- Mechanism drains water when activated
- Simple cause-and-effect

**Type 2: Sequence Locks**
- Must input correct glyph sequence
- Example: Door requires [APERIRE] + [TEMPUS] (opens after delay)

**Type 3: Conditional Logic**
- Use triangle modifier for "if/then"
- Example: [AQUA] inside △ + [ROTARE] = "If water present, then rotate"

**Type 4: Multi-Panel Sequences**
- Multiple panels must be activated in order
- Each panel's output feeds into next
- Example: Panel 1 fills reservoir → Panel 2 freezes water → Panel 3 opens gate

**Type 5: Reverse Engineering**
- See the result, must deduce the sequence
- Example: Door opens, must figure out what glyphs would cause that

### **6.4 Combined Puzzles (Late Game)**

**Example Mega-Puzzle:**
```
Room: The Cascading Prism

Environment:
- Water channel (currently dry)
- Rotating prism in center
- Light source at west
- Exit door at east (locked)
- Grated floor sections
- Three control panels

Glyph Clues:
- Panel A inscription: [AQUA] + [FLOW] + [LUMEN]
- Panel B inscription: [ROTARE] + [VISIO] + [TEMPUS]
- Panel C inscription: [APERIRE] inside △ + [LUMEN]

Solution:
1. Activate Panel A: Water flows and becomes luminescent
2. Shift to Macro: Rotate prism to correct angle
3. Shift to Normal: Observe light beam path
4. Activate Panel B: Prism begins slowly rotating
5. Shift to Micro: Fall through grate to lower level
6. Observe light beam hitting crystal at lower level
7. Light beam powers mechanism over time
8. When powered, Panel C's conditional triggers
9. Translation: "Open when light is present"
10. Door unlocks
```

This puzzle combines:
- Water mechanics
- Scale shifting (all three scales)
- Light/vision
- Rotation
- Time
- Conditional logic
- Multi-level navigation

---

## **7. NARRATIVE & LORE**

### **7.1 Core Story**

**The Ancient Civilization:**
- Mastered understanding reality at multiple scales
- Built the Engine as their greatest achievement
- Vanished mysteriously (or transcended? or failed?)
- Left temple as testament/warning/gift

**The Engine's Purpose (Revealed Gradually):**
- [Option A]: Reality anchor - keeps dimensions stable
- [Option B]: Civilization seed - births new worlds
- [Option C]: Knowledge repository - preserves understanding
- [Option D]: Transformation device - ascends consciousness
- Player discovers truth through inscriptions and murals

**The Player Character:**
- Awakens with no memory
- Unclear if ancient inhabitant, recent explorer, or something else
- Identity revealed through optional lore collection
- Can roleplay motivation (restore? destroy? understand? claim?)

### **7.2 Environmental Storytelling**

**Storytelling Methods:**
- **Murals**: Show historical events, civilization's rise and fall
- **Inscriptions**: Glyph sequences that tell stories when translated
- **Architecture**: Temple design reflects civilization's values
- **Objects**: Personal items, tools, remnants of daily life
- **Echo-stones**: Voice recordings (in ancient language) with emotional tone

**Story Beats Per Dungeon:**
- **Dungeon 1**: Introduction to civilization, their daily life with water
- **Dungeon 2**: Their mastery of time and mechanics
- **Dungeon 3**: Their pursuit of knowledge and vision
- **Dungeon 4**: Their control over elements
- **Dungeon 5**: Their understanding of logic and recursion
- **Dungeon 6**: Their communication and memory preservation
- **Dungeon 7**: The truth about the Engine and their fate

**Optional Lore Collectibles:**
- Hidden tablets (100% completion bonus)
- Personal journals (give individual perspectives)
- Archaeological notes from recent explorers (meta-commentary)

### **7.3 Themes**

**Primary Themes:**
- **Understanding through observation** - Knowledge comes from paying attention
- **Language as power** - Communication enables progress
- **Scale and perspective** - Problems change when viewed differently
- **Legacy and choice** - What we leave behind, what we do with what we find

**Secondary Themes:**
- The relationship between creator and creation
- Whether knowledge should be preserved or destroyed
- Individual versus civilization
- Progress versus preservation

---

## **8. ART & AUDIO DIRECTION**

### **8.1 Visual Style**

**Overall Aesthetic:**
- Clean, readable 2D sprites
- Link's Awakening remake inspiration (depth without full 3D)
- Soft shadows for depth perception
- Distinct color palette per dungeon
- Glyphs designed for clarity at all sizes

**Color Palettes:**
- **Dungeon 1 (Hydraulic)**: Blues, teals, white (water, stone)
- **Dungeon 2 (Clockwork)**: Brass, gold, bronze (metal, gears)
- **Dungeon 3 (Prismatic)**: Yellows, whites, rainbows (light, glass)
- **Dungeon 4 (Forge)**: Reds, oranges, blues (fire, ice)
- **Dungeon 5 (Recursion)**: Purples, silvers, blacks (abstract, logic)
- **Dungeon 6 (Archives)**: Greens, browns, aged paper (knowledge, age)
- **Dungeon 7 (Engine Heart)**: All colors mixed (synthesis)

**Animation Priorities:**
- Player movement (8 directions, smooth)
- Water flow (gentle, mesmerizing)
- Scale transition (particle effects, size change)
- Gear rotation (satisfying mechanical motion)
- Glyph glow (when active or discovered)

**UI Design:**
- Minimalist, non-intrusive
- Notebook feels handcrafted (sketches, handwriting)
- Control panels have ancient, carved appearance
- Quiz gates feel ceremonial, important

### **8.2 Audio Design**

**Music Style:**
- Ambient, atmospheric (not distracting during puzzle-solving)
- Subtle melodies that build per dungeon
- Each dungeon has distinct musical identity
- Final dungeon combines all musical themes

**Sound Effects:**
- **Water**: Flowing, dripping, splashing (varies by scale)
- **Stone**: Grinding, clicking into place
- **Gears**: Mechanical turning, ticking
- **Scale shift**: Whoosh, magical resonance
- **Glyph activation**: Pleasant chime
- **Door unlock**: Satisfying mechanical sound
- **Footsteps**: Change based on scale and surface

**Echo-Stone Voice Acting:**
- Ancient language (constructed or modified real language)
- Emotional tone conveys meaning even if words don't
- Reverb and effects for mystical quality

**Ambient Sounds:**
- Each dungeon has subtle background sounds
- Water Garden: Fountains, distant waterfalls
- Clockwork: Ticking, distant gears
- Prismatic: Crystal resonance, light hum
- Forge: Crackling fire, hissing steam
- Recursion: Ethereal tones, echoes
- Archives: Papers rustling, faint whispers
- Engine Heart: All sounds combined, pulsing heartbeat

---

## **9. TECHNICAL SPECIFICATIONS**

### **9.1 Platform & Engine**

**Primary Platform:** Steam (PC)
- **Minimum Specs**: 
  - OS: Windows 10, macOS 10.15, Ubuntu 20.04
  - CPU: Dual-core 2.0 GHz
  - RAM: 4 GB
  - GPU: Integrated graphics with OpenGL 3.3
  - Storage: 2 GB

**Engine:** Godot 4.x
- Open-source, free
- Excellent 2D support
- Built-in scene system (perfect for room-based design)
- Good tilemap editor
- Easy Steam integration via plugins
- Cross-platform export

**Resolution:** 1920x1080 native, scalable

**Frame Rate:** 60 FPS target

### **9.2 Core Systems Architecture**

**Game Manager:**
- Scene loading/unloading
- Save/load system
- Global state management
- Settings management

**Player Controller:**
- Movement (8-directional)
- Interaction system
- Scale state machine
- Animation controller

**Scale System:**
- Current scale state (Normal/Micro/Macro)
- Scale transition logic
- Collision layer management per scale
- Visual size interpolation

**Glyph System:**
- Glyph database (all 27 + modifiers)
- Discovery tracking per glyph
- Hypothesis storage
- Validation state

**Notebook System:**
- UI manager
- Glyph entry display
- Evidence gallery
- Hypothesis input
- Search/filter

**Control Panel System:**
- Panel type identification
- Glyph slot management
- Drag-and-drop UI
- Sequence validation
- Mechanism triggering

**Mechanism System:**
- Water flow control
- Gear rotation
- Door states
- Platform movement
- Light beam activation

**Quiz Gate System:**
- Match interface
- Attempt counter
- Score calculator
- Feedback manager
- Progression gate

**Save System:**
- Player position/scale
- Glyph discoveries
- Room completion states
- Notebook entries
- Quiz attempts
- Mechanism states

### **9.3 Data Structures**

**Glyph Data:**
```gdscript
class_name GlyphData

var id: String  # "AQUA", "PETRA", etc.
var symbol_texture: Texture2D
var discovered: bool = false
var player_hypothesis: String = ""
var confirmed: bool = false
var correct_meaning: String
var locations_found: Array[String] = []
var category: String  # "SUBSTANCE", "STATE", "ACTION", etc.
```

**Room Data:**
```gdscript
class_name RoomData

var room_id: String
var dungeon_id: String
var visited: bool = false
var completed: bool = false
var glyphs_present: Array[String] = []
var mechanisms_state: Dictionary = {}
var scale_restrictions: Dictionary = {
    "allow_micro": true,
    "allow_macro": true
}
```

**Player Save Data:**
```gdscript
class_name PlayerSaveData

var current_room: String
var current_scale: String  # "NORMAL", "MICRO", "MACRO"
var position: Vector2
var glyphs_discovered: Dictionary  # glyph_id: GlyphData
var rooms_completed: Array[String]
var quiz_attempts: Dictionary  # quiz_id: attempt_count
var total_playtime: float
```

### **9.4 Performance Optimization**

**Room Loading:**
- Load adjacent rooms in background
- Unload distant rooms
- Keep current + 1 room radius in memory

**Sprite Batching:**
- Use tilemaps for terrain
- Batch similar objects
- Minimize draw calls

**Particle Effects:**
- Pool particle systems
- Limit simultaneous effects
- Scale complexity with performance

**Audio:**
- Stream music
- Load SFX on-demand
- Spatial audio only for nearby sources

---

## **10. DEVELOPMENT ROADMAP**

### **10.1 Phase 1: Prototype (Tutorial Build) - 3-4 Months**

**Month 1: Core Systems**
- Player movement controller
- Basic tilemap and room system
- Scale-shifting mechanic (all three scales)
- Collision system per scale

**Month 2: Glyph & Puzzle Systems**
- Glyph database implementation
- Notebook UI (basic)
- Control panel system
- First 5 glyphs functional
- Quiz gate system

**Month 3: Content & Polish**
- Build Rooms 1-1 through 1-7
- Create all art assets for tutorial
- Implement first quiz gate
- Sound effects and music (basic)
- Playtesting and iteration

**Month 4: Tutorial Release**
- Bug fixing
- Performance optimization
- Steam page setup
- Tutorial published as free demo
- Gather feedback

**Deliverable:** Playable tutorial on Steam (free)

### **10.2 Phase 2: Full Game Development - 12-18 Months**

**Months 5-7: Dungeons 1-2 Complete**
- Finish all rooms in Dungeon 1
- Build entire Dungeon 2
- All glyph systems for both dungeons
- Boss puzzles for both
- Quiz gates

**Months 8-10: Dungeons 3-4**
- Build Dungeon 3 (Prismatic)
- Build Dungeon 4 (Forge)
- Light/vision mechanics
- Fire/ice/temperature systems
- Elemental interactions

**Months 11-13: Dungeons 5-6**
- Build Dungeon 5 (Recursion)
- Build Dungeon 6 (Archives)
- Grammar/logic systems
- Sound-based puzzles
- Complex compound glyphs

**Months 14-16: Dungeon 7 & Endings**
- Build final dungeon
- All combined mechanics
- Multiple ending sequences
- Final boss puzzle
- Ending cinematics (minimal)

**Months 17-18: Polish & Release**
- Full playthrough testing
- Balance puzzle difficulty
- Optimize performance
- Localization (if budget allows)
- Marketing materials
- Steam release

**Deliverable:** Full game on Steam

### **10.3 Phase 3: Post-Launch - Ongoing**

**Month 19+:**
- Bug fixes from player feedback
- Quality of life improvements
- Optional: Additional dungeons (DLC)
- Optional: Level editor (community content)
- Optional: Speedrun mode

---

## **11. MARKETING & RELEASE STRATEGY**

### **11.1 Target Audience**

**Primary Audience:**
- Puzzle game enthusiasts (Portal, The Witness, Baba Is You)
- Language learning game fans (Chants of Sennaar, Heaven's Vault)
- Indie game supporters
- Players who enjoy environmental storytelling

**Age Range:** 12+ (no violence, pure puzzles)

**Geographic:** Global (minimal text, universal symbols)

### **11.2 Marketing Plan**

**Pre-Release (Tutorial Phase):**
- Steam page with trailer
- Devlog on itch.io or GameDev forums
- Social media presence (Twitter, Reddit r/gamedev, r/indiegames)
- GIFs showing scale-shifting puzzles
- Screenshots of glyph learning system

**Tutorial Launch:**
- Free demo on Steam
- "Wishlist the full game" call-to-action
- Gather feedback from players
- Build community on Discord

**Full Game Marketing:**
- Reach out to puzzle game YouTubers/streamers
- Submit to indie game festivals
- Press releases to gaming sites
- Emphasize unique language learning hook
- Highlight "no combat, pure puzzles" angle

**Launch Window:** Avoid major releases, target early/mid year

### **11.3 Pricing Strategy**

**Tutorial:** Free (demo/wishlist driver)

**Full Game:** $14.99-$19.99 USD
- Comparable to Chants of Sennaar ($19.99)
- 12-15 hour playtime justifies price
- Launch discount: 10-15% off

**Post-Launch:**
- Regular sales (seasonal Steam sales)
- Possible bundle with other puzzle games
- DLC dungeons: $4.99-$6.99 if developed

---

## **12. SUCCESS METRICS**

### **12.1 Tutorial Success**

**Targets:**
- 10,000+ wishlists before full game launch
- 80%+ completion rate for tutorial
- Average 4.0+ Steam rating
- Players understand core mechanics (survey data)

### **12.2 Full Game Success**

**Targets:**
- 50,000+ copies sold in first year
- 85%+ positive Steam reviews
- Average playtime: 10+ hours
- 30%+ completion rate (finish all dungeons)
- 5%+ 100% achievement rate

### **12.3 Community Engagement**

**Targets:**
- Active Discord community (500+ members)
- Player-created guides for puzzles
- Speedrun community emergence
- Fan art and content creation

---

## **13. RISK ASSESSMENT**

### **13.1 Development Risks**

**Risk: Puzzle difficulty balance**
- Mitigation: Extensive playtesting, tutorial feedback
- Players should feel challenged but never stuck

**Risk: Glyph learning curve too steep**
- Mitigation: Clear visual design, adequate context clues
- Ensure first 5 glyphs teach system well

**Risk: Scope creep**
- Mitigation: Stick to 7 dungeon plan, resist feature bloat
- Tutorial validates core concept before full investment

**Risk: Performance issues**
- Mitigation: Regular optimization, target modest specs
- Godot's 2D performance is generally excellent

### **13.2 Market Risks**

**Risk: Niche audience**
- Mitigation: Unique hook (language + scale), strong marketing
- Free tutorial lowers barrier to entry

**Risk: Competing with larger titles**
- Mitigation: Indie identity, unique mechanics, community focus
- Avoid launching against major puzzle games

**Risk: Platform limitations (Steam only)**
- Mitigation: Consider console ports post-launch if successful
- Godot exports to Switch, PlayStation, Xbox

---

## **14. TEAM STRUCTURE**

### **14.1 Minimum Team (Solo/Small)**

**Core Roles:**
- **Developer/Designer**: Core systems, puzzles, scripting
- **Artist**: Sprites, tiles, UI, glyphs
- **Composer/Sound Designer**: Music, SFX

**Optional:**
- **Playtester(s)**: Feedback on puzzles
- **Localization**: If budget allows

### **14.2 Recommended Skills**

**Developer:**
- Godot/GDScript proficiency
- 2D game mechanics
- State machine design
- UI/UX implementation

**Artist:**
- Pixel art or clean 2D style
- Symbol/icon design (for glyphs)
- Color theory (distinct dungeon palettes)
- Animation (basic character movement)

**Composer:**
- Ambient/atmospheric music
- Adaptive music (layer-based)
- Sound design for environment

---

## **15. APPENDIX**

### **15.1 Glyph Quick Reference**

**Complete Glyph List (27 Base):**

**Substances (6):**
- AQUA - Water/liquid
- PETRA - Stone/earth/solid
- IGNIS - Fire/heat/light
- GLACIES - Ice/frozen/cold
- AETHER - Air/void/space
- FERRUM - Metal/mechanism

**States (6):**
- FLOW - Movement/flowing/active
- STASIS - Still/stopped/inactive
- LUMEN - Bright/illuminated/visible
- UMBRA - Dark/hidden/obscured
- MAGNUS - Large/great/expanded
- PARVUS - Small/tiny/reduced

**Actions (6):**
- ASCENDE - Rising/upward/increase
- DESCENDE - Falling/downward/decrease
- ROTARE - Turning/rotating/cycling
- APERIRE - Opening/revealing/unlocking
- CLAUDERE - Closing/sealing/locking
- MUTARE - Changing/transforming/becoming

**Perceptions (4):**
- VISIO - Sight/seeing/observation
- AUDIO - Sound/hearing/echo
- TACTUS - Touch/physical/solid
- MENSURA - Measurement/scale/proportion

**Temporal (3):**
- TEMPUS - Time/duration/passage
- MORA - Delay/waiting/pause
- CELERITAS - Speed/rapid/immediate

**Modifiers (4):**
- Circle (○) - Continuous/always/eternal
- Triangle (△) - Conditional/if/when
- Line-through (⌀) - Negation/not/opposite
- Double-border - Emphasis/strong/required

**Total: 27 base + 4 modifiers = 31 symbols**

### **15.2 Example Compound Phrases**

**Simple (2 glyphs):**
- AQUA + FLOW = "Water flows"
- PETRA + MAGNUS = "Large stone"
- IGNIS + LUMEN = "Fire gives light"

**Medium (3 glyphs):**
- AQUA + TEMPUS + ASCENDE = "Water rises over time"
- FERRUM + ROTARE + CELERITAS = "Metal turns quickly"
- VISIO + MENSURA + PARVUS = "See the small/details"

**Complex (4-5 glyphs):**
- AQUA + MUTARE + GLACIES + STASIS = "Water becomes ice and stops"
- [IGNIS inside ○] + LUMEN + VISIO = "Eternal fire reveals sight"
- [TEMPUS inside △] + ROTARE + APERIRE = "When time passes, turning opens"

**Advanced (with modifiers):**
- [FLOW with ⌀] = "No movement" / "Stopped"
- [AQUA inside ○] + ASCENDE = "Water continuously rises"
- [PETRA inside △] + APERIRE = "If stone, then open" / "Stone unlocks conditionally"

### **15.3 Control Panel Examples**

**Example 1: Simple Drain**
```
╔════════════════════╗
║  [AQUA] [DESCENDE] ║
║                    ║
║     [Activate]     ║
╚════════════════════╝
```
Result: Water drains downward

**Example 2: Timed Lock**
```
╔════════════════════╗
║  [TEMPUS] [MORA]   ║
║         ↓          ║
║     [APERIRE]      ║
║                    ║
║     [Activate]     ║
╚════════════════════╝
```
Result: After delay, door opens

**Example 3: Conditional Mechanism**
```
╔════════════════════════════╗
║  [AQUA inside △]           ║
║         ↓                  ║
║  [ROTARE] [FERRUM]         ║
║                            ║
║  Translation:              ║
║  "If water present,        ║
║   then metal rotates"      ║
║                            ║
║     [Activate]             ║
╚════════════════════════════╝
```
Result: Gear only turns if water is in the system

**Example 4: Complex Sequence**
```
╔════════════════════════════╗
║  Step 1: [AQUA] [FLOW]     ║
║  Step 2: [GLACIES] [MUTARE]║
║  Step 3: [STASIS]          ║
║                            ║
║  Translation:              ║
║  "Water flows,             ║
║   becomes ice,             ║
║   then stops"              ║
║                            ║
║     [Execute Sequence]     ║
╚════════════════════════════╝
```
Result: Water flows into chamber, freezes into bridge, stops moving

---

## **END OF PRD**

**Document Version:** 1.0  
**Last Updated:** January 2026  
**Status:** Ready for Development

**Next Steps:**
1. Review and approve PRD
2. Set up development environment (Godot 4.x)
3. Create initial project structure
4. Begin Phase 1: Tutorial prototype
5. Establish art style guide
6. Create first glyph designs

**Contact for Questions/Revisions:**
[Your contact information]

---

**This PRD is a living document and will be updated as development progresses and new insights are gained.**
