extends Control
class_name ChatSuggestedCard

@onready var suggestion: RichTextLabel = %Suggestion
@onready var username: RichTextLabel = %Username

func set_details(submission: String, twitch_name: String) -> void:
	suggestion.text = "'" + submission + "'"
	username.text = "from: " + twitch_name
