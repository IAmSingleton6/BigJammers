extends WorldEnvironment
class_name FeelWorldEnvironment

static var FEELWORLDENVIRONMENTGROUPNAME = "FeelWorldEnvironment"
# Horrible but quick
@export var vignette: ColorRect


func _ready():
	add_to_group(FEELWORLDENVIRONMENTGROUPNAME)
	if vignette:
		# Horrible but quick fix for feel component not resetting on scene switch
		vignette.material.set_shader_parameter("intensity", 0.0)
