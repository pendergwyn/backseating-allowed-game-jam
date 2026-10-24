extends Control

const MIN_STEP: float = 5.0

@onready var color_palette : ColorPallette = %ColorPalette
@onready var brush_size : HSlider = %BrushSize
@onready var brush_size_label : Label = %BrushSizeLabel
@onready var history_log: RichTextLabel = %HistoryLog

var paint_history : Array = []
var line_width : float = 7.0
var stroke : Line2D = null

func _ready() -> void:
	brush_size.value = line_width
	brush_size_label.text = "Brush Size: " + str(brush_size.value)
	history_log.text = ""

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			stroke = _new_stroke()
			stroke.add_point(event.position)
		else:
			stroke = null
	elif event is InputEventMouseMotion and stroke != null:
		if stroke.points[-1].distance_to(event.position) > MIN_STEP:
			stroke.add_point(event.position)
	
	if event.is_action_pressed("brush_size_increase"):
		_update_line_width(0.5)
	if event.is_action_pressed("brush_size_decrease"):
		_update_line_width(-0.5)
	if event.is_action_pressed("undo"):
		_undo_action()

func _new_stroke() -> Line2D:
	var line: Line2D = Line2D.new()
	line.width = line_width
	line.default_color = color_palette.current_color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.antialiased = true
	paint_history.append(line)
	add_child(line)
	
	_update_history_log()
	
	return line

func _update_line_width(value: float) -> void:
	line_width += value
	if line_width >= brush_size.max_value:
		line_width = brush_size.max_value
	elif line_width <= brush_size.min_value:
		line_width = brush_size.min_value
	brush_size.value = line_width
	brush_size_label.text = "Brush Size: " + str(brush_size.value)

func _undo_action() -> void:
	if paint_history.is_empty():
		return
	else:
		var last_action = paint_history.pop_back()
		last_action.queue_free()
		_update_history_log()

func _update_history_log() -> void:
	var current_log = history_log.text
	history_log.text = ""
	for step in paint_history.size():
		var color_used = paint_history[step].default_color
		history_log.text = ">> " + str(color_used) + str(paint_history[step]) + "[br]" + current_log
