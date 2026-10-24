extends VBoxContainer
class_name ColorPallette

@onready var selected_color : ColorRect = %SelectedColor
@onready var red_color: ColorRect = %RedColor
@onready var yellow_color: ColorRect = %YellowColor
@onready var white_color: ColorRect = %WhiteColor
@onready var black_color: ColorRect = %BlackColor

var current_color : Color = Color.WHITE

func _ready() -> void:
	selected_color.color = current_color
	red_color.gui_input.connect(_color_change.bind(red_color.color))
	yellow_color.gui_input.connect(_color_change.bind(yellow_color.color))
	white_color.gui_input.connect(_color_change.bind(white_color.color))
	black_color.gui_input.connect(_color_change.bind(black_color.color))

func _color_change(event: InputEvent, new_color) -> void:
	if event.is_action_pressed("left_mouse"):
		current_color = new_color
		selected_color.color = current_color
