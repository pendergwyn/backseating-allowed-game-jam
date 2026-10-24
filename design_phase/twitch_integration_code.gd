extends Node

@onready var twitch_service : TwitchService = %TwitchService
@onready var request_command: TwitchCommand = %RequestCommand


func _ready():
	var setup_successful: bool = await twitch_service.setup()
	
	if setup_successful:
		print("Twitch Service successfully set up and authenticated!")
	else:
		printerr("Twitch Service setup failed. Check authentication.")

	request_command.command_received.connect(_on_request)
	request_command.invalid_permission.connect(_invalid_permission)
	request_command.received_invalid_command.connect(_invalid_command)
	request_command.cooldown.connect(_cooldown)

func _on_request(_from_username: String, info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	print("Request received!" + "From: " + str(_from_username))

func _invalid_permission() -> void:
	print("Invalid Permission")

func _invalid_command() -> void:
	print("Invalid Comment")

func _cooldown() -> void:
	print("Cooldown")
