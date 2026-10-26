extends Sprite2D
class_name TripodCamera

@onready var vision_cone: CollisionPolygon2D = %VisionCone

func turn_actions() -> void:
	var rotate_to = vision_cone.rotation_degrees + 45.0
	_rotate_camera(rotate_to)

func _rotate_camera(rotate_to : float) -> void:
	vision_cone.rotation_degrees = rotate_to
