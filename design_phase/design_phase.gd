extends Node2D

enum State {
	ANTENNA,
	BODY,
	ARMS,
	LEGS,
}

var current_state : State = State.ANTENNA

@onready var request_list: RichTextLabel = %RequestList
@onready var antenna: AnimatedSprite2D = %Antenna
@onready var body: AnimatedSprite2D = %Body
@onready var arms: AnimatedSprite2D = %Arms
@onready var legs: AnimatedSprite2D = %Legs
@onready var body_button: Button = %BodyButton
@onready var arms_button: Button = %ArmsButton
@onready var legs_button: Button = %LegsButton
@onready var antenna_button: Button = %AntennaButton
@onready var previous_button: Button = %PreviousButton
@onready var next_button: Button = %NextButton
@onready var label: Label = %Label
@onready var request_command : TwitchCommand = %RequestCommand
@onready var save_button : Button = %SaveButton
@onready var monster_design : Node2D = %Monster
@onready var subviewport : SubViewport = %SubViewport

var request_deck : Array[PackedStringArray] = []
var current_part : AnimatedSprite2D
var total_frames : int

func _ready() -> void:
	request_list.text = str(request_deck)
	antenna_button.pressed.connect(_antenna_button_pressed)
	body_button.pressed.connect(_body_button_pressed)
	arms_button.pressed.connect(_arms_button_pressed)
	legs_button.pressed.connect(_legs_button_pressed)
	previous_button.pressed.connect(_previous_button_pressed)
	next_button.pressed.connect(_next_button_pressed)
	save_button.pressed.connect(_save_button_pressed)
	
	## Twitch Signal Connections
	request_command.command_received.connect(_on_request)

func _process(delta) -> void:
	request_list.text = str(request_deck)	
	label.text = "Currently Editing: " + str(State.keys()[current_state])
	
	match current_state:
		State.ANTENNA:
			current_part = antenna
		State.BODY:
			current_part = body
		State.ARMS:
			current_part = arms
		State.LEGS:
			current_part = legs
			

func _previous_button_pressed() -> void:
	total_frames = current_part.sprite_frames.get_frame_count("default")
	if current_part.frame == 0:
		current_part.frame = (total_frames - 1)
	else:
		current_part.frame -= 1

func _next_button_pressed() -> void:
	total_frames = current_part.sprite_frames.get_frame_count("default")
	if current_part.frame >= (total_frames-1):
		current_part.frame = 0
	else:
		current_part.frame += 1

func _save_button_pressed() -> void:
	monster_design.reparent(subviewport)
	monster_design.position = Vector2(250.0, 250.0)
	await RenderingServer.frame_post_draw
	subviewport.get_texture().get_image().save_png("res://assets/created_monsters/monster.png")
	monster_design.reparent(get_tree().root)
	monster_design.position = Vector2(640.0, 360.0)

func _antenna_button_pressed() ->  void:
	current_state = State.ANTENNA

func _body_button_pressed() -> void:
	current_state = State.BODY

func _arms_button_pressed() -> void:
	current_state = State.ARMS

func _legs_button_pressed() -> void:
	current_state = State.LEGS

func _on_request(_from_username: String, info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	request_deck.append(_args)
	print("Request Submitted: " + str(_args))
