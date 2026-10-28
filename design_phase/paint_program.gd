extends Control

const MIN_STEP: float = 5.0

@onready var color_palette : ColorPallette = %ColorPalette
@onready var brush_size : HSlider = %BrushSize
@onready var brush_size_label : Label = %BrushSizeLabel
@onready var history_log: RichTextLabel = %HistoryLog
@onready var monster : Node2D = %Monster
@onready var paint_cursor: AnimatedSprite2D = %PaintCursor

var paint_history : Array = []
var line_width : float = 7.0
var stroke : Line2D = null
var line_offset : Vector2 = Vector2(640.0, 325.0)
var in_drawable_area : bool = false

func _ready() -> void:
	brush_size.value = line_width
	brush_size_label.text = "Brush Size: " + str(brush_size.value)
	history_log.text = ""

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and in_drawable_area == true:
		if event.is_pressed():
			stroke = _new_stroke()
			stroke.add_point(event.position - line_offset)
		else:
			stroke = null
	elif event is InputEventMouseMotion and stroke != null:
		if stroke.points[-1].distance_to(event.position - line_offset) > MIN_STEP:
			stroke.add_point(event.position - line_offset)
	
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
	monster.add_child(line)
	
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
		#_update_history_log()

func _update_history_log() -> void:
	var current_log = history_log.text
	history_log.text = ""
	for step in paint_history.size():
		var color_used : Color = paint_history[step].default_color
		var color_hex = color_used.to_html(false)
		history_log.text = ">> " + "[color=#%s]" % color_hex  + str(paint_history[step]) + "[/color][br]" + current_log


func _on_panel_container_mouse_entered() -> void:
	in_drawable_area = true
	paint_cursor.frame = 0


func _on_panel_container_mouse_exited() -> void:
	in_drawable_area = false
	paint_cursor.frame = 1
