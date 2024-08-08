extends FeelComponent
class_name FeelCameraZoom

@export var camera: Camera2D
@export var zoom_scale: float = 1.1
@export var duration: float = 0.3
@export var restore_original_zoom := true


func play() -> void:
	print("zoom camera feel")
	var i_zoom = camera.zoom
	var target_zoom = i_zoom * zoom_scale
	var tween = get_tree().create_tween()
	
	tween.tween_property(camera, "zoom", target_zoom, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	if restore_original_zoom:
		tween.tween_property(camera, "zoom", i_zoom, duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(_stop)
	
	tween.play()


func _stop():
	stop()
