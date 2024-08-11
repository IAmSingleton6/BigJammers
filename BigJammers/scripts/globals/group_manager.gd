class_name GroupManager

# IMPORTANT
# Add correct groups to correct area 2Ds/static bodies
# Each block should have the block group
# Each block should have its specific group 
# Each level mechanic should have its specific group

# Used to find the player in the scene or check for entire player body in interaction
static var PLAYERGROUP = "Player"

# Used to detect if heart should take damage
static var HEARTGROUP = "Heart"

# Used to check amount of blocks in the scene (apply to root of blocks)
static var BLOCKGROUP = "Block"

# Specific block types
static var WATERGROUP = "Water"
static var FIREGROUP = "Fire"
static var TIMERGROUP = "Timer"
static var ELECTRICGROUP = "Electric"
static var ICEGROUP = "Ice"

# Level mechanics
static var LASERGROUP = "Laser"
static var WINDGROUP = "Wind"
static var KILLZONE = "Killzone"
