extends VBoxContainer
class_name ColorPallette

@onready var selected_color : ColorRect = %SelectedColor

@onready var white_color: TextureRect = %WhiteColor
@onready var black_color: TextureRect = %BlackColor

var current_color : Color = Color.WHITE

func _ready() -> void:
	selected_color.color = current_color
	
	var color_options = get_tree().get_nodes_in_group("color_options")
	for color : TextureRect in color_options:
		color.gui_input.connect(_color_change.bind(color.hex_color))

func _color_change(event: InputEvent, new_color) -> void:
	if event.is_action_pressed("left_mouse"):
		current_color = new_color
		selected_color.color = current_color
		SignalBus.new_color_chosen.emit()
