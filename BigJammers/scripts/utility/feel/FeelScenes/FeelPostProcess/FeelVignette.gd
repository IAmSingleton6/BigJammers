extends FeelComponent
class_name FeelVignette

@export_range(0.0, 10.0) var intensity := 1.0
@export var duration := 0.5
@export var return_to_original_intensity := false

var vignette: ColorRect


func play():
	var post_p = get_tree().get_first_node_in_group(FeelWorldEnvironment.FEELWORLDENVIRONMENTGROUPNAME)
	if not post_p:
		return
	
	vignette = (post_p as FeelWorldEnvironment).vignette
	if not vignette:
		return
	
	var start_intensity: float = vignette.material.get_shader_parameter("intensity")
	var tween = get_tree().create_tween()
	
	tween.tween_method(_set_shader_param, start_intensity, intensity, duration);
	if return_to_original_intensity:
		tween.tween_method(_set_shader_param, intensity, start_intensity, duration);
	tween.finished.connect(_stop)


func _set_shader_param(value):
	if vignette:
		vignette.material.set_shader_parameter("intensity", value)


func _stop():
	stop()
