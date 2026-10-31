extends PanelContainer
class_name ChatSuggestionsFeed

@onready var suggestions_container: VBoxContainer = %SuggestionsContainer

var suggestion_label : PackedScene = preload("res://design_phase/chat_suggestion_label.tscn")
var message_text : PackedStringArray
var from_user : String

func _ready() -> void:
	SignalBus.new_suggestion_added.connect(_add_suggestion.bind())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		message_text = (["submission"])
		from_user = "pendergwyn"
		_add_suggestion()

func _add_suggestion() -> void:
		print("Running")
		var new_entry = suggestion_label.instantiate()
		var entry_text = "".join(message_text)
		new_entry.add_to_group("entries")
		new_entry.text = entry_text.to_upper()
		suggestions_container.add_child(new_entry)
		suggestions_container.move_child(new_entry, 0)
