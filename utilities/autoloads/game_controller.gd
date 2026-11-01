extends Node

var secret_card : ChatSuggestedCard
var cards_dealt : bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
