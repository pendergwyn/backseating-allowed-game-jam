@tool
extends HBoxContainer
class_name BodyPartSelection

@export_enum("Antenna", "Body", "Arms", "Legs") var body_type: String:
	set(set_body):
		body_type = set_body
		_update_container_details()

@export var parts : BodyPartTypes
		
@onready var previous_button: TextureButton = %PreviousButton
@onready var _body_part_name: RichTextLabel = %BodyPartName
@onready var next_button: TextureButton = %NextButton

var current_part

func _ready() -> void:
	_body_part_name.text = body_type

func _update_container_details() -> void:
	if Engine.is_editor_hint():
		_body_part_name.text = body_type
