extends Camera2D
class_name CameraController

var zoom_level : Vector2 = Vector2(3.0, 3.0)
var zoom_increment : Vector2 = Vector2(0.2, 0.2)
var camera_pan_speed : float = 400.0
var camera_pan_acceleration : float = 0.5
var camera_pan_friction : float = 0.10
var camera_pan_direction : Vector2 = Vector2(0.0, 0.0)
var snap_to_player : bool = false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_zoom_in"):
		zoom += zoom_increment 
	if event.is_action_pressed("camera_zoom_out"):
		zoom -= zoom_increment

func _process(delta: float) -> void:
	var horizontal_direction = signf(Input.get_axis("camera_pan_left", "camera_pan_right"))
	var vertical_direction = signf(Input.get_axis("camera_pan_up", "camera_pan_down"))
	camera_pan_direction = Vector2(horizontal_direction, vertical_direction)
	
	var is_panning := camera_pan_direction != Vector2(0.0, 0.0)
	if is_panning:
		offset += ((camera_pan_direction.normalized() * camera_pan_speed) / zoom) * delta
	else:
		pass
	
	if snap_to_player == true:
		if offset != Vector2(0.0, 0.0):
			snap_camera()
	
	if abs(offset) < Vector2(0.01, 0.01):
		snap_to_player = false


func snap_camera() -> void:
	offset = lerp(offset, Vector2(0.0, 0.0), camera_pan_acceleration)

func _on_camera_snap_back_button_pressed() -> void:
	snap_to_player = true
