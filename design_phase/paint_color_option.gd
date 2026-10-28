@tool
extends TextureRect

@export var color_info : PaintColors:
	set(new_color):
		color_info = new_color
		_update_color_data()

var hex_color : Color
var locked : bool
var price : int

func _ready() -> void:
	add_to_group("color_options")

func _update_color_data() -> void:
	texture = color_info.palette_image
	hex_color = color_info.hex_color
	locked = color_info.locked
	price = color_info.price
