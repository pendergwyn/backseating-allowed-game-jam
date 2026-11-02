extends Node

var secret_card : ChatSuggestedCard
var cards_dealt : bool = false
var selected_body_type : String

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
