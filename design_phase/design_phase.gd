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
@onready var label: Label = %Label
@onready var request_command : TwitchCommand = %RequestCommand
@onready var save_button : Button = %SaveButton
@onready var monster_design : Node2D = %Monster
@onready var subviewport : SubViewport = %SubViewport
@onready var ui_click: AudioStreamPlayer2D = %UIClick
@onready var chat_instructions: PanelContainer = %ChatInstructions
@onready var chat_suggestions_feed: ChatSuggestionsFeed = %ChatSuggestionsFeed
@onready var suggestions_feed_and_button_container: VBoxContainer = %SuggestionsFeedAndButtonContainer
@onready var game_intro: Control = %GameIntro
@onready var prompt_cards: HBoxContainer = %PromptCards
@onready var join_command: TwitchCommand = %JoinCommand
@onready var shuffle_requests: Button = %ShuffleRequests
@onready var ui_container: Control = %UIContainer
@onready var game_title: PanelContainer = %GameTitle
@onready var lets_draw_button: Button = %LetsDrawButton
@onready var paint: Control = %Paint
@onready var monster_drawing_panel: PanelContainer = %MonsterDrawingPanel
@onready var body_part_selector: VBoxContainer = %BodyPartSelector
@onready var player_hand: Control = %PlayerHand
@onready var player_hand_container: VBoxContainer = %PlayerHandContainer

var chat_suggestion_card : PackedScene = preload("res://design_phase/chat_suggested_card.tscn")
var chat_character : PackedScene = preload("res://design_phase/chat_character.tscn")
var deck_shuffle : PackedScene = preload("res://design_phase/deck_shuffling_animation.tscn")
var request_deck : Array[PackedStringArray] = []
var request_dictionary : Dictionary = {}
var current_part : AnimatedSprite2D
var total_frames : int
var deck_build_begin : bool = false

func _ready() -> void:
	request_list.text = str(request_deck)
	antenna_button.pressed.connect(_antenna_button_pressed)
	body_button.pressed.connect(_body_button_pressed)
	arms_button.pressed.connect(_arms_button_pressed)
	legs_button.pressed.connect(_legs_button_pressed)
	
	save_button.pressed.connect(_save_button_pressed)
	
	SignalBus.new_color_chosen.connect(_play_click_sound)
	SignalBus.cards_dealt.connect(_start_game)
	
	## Twitch Signal Connections
	request_command.command_received.connect(_on_request)
	join_command.command_received.connect(_on_join)

func _process(_delta) -> void:
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
	_play_click_sound()
	total_frames = current_part.sprite_frames.get_frame_count("default")
	if current_part.frame == 0:
		current_part.frame = (total_frames - 1)
	else:
		current_part.frame -= 1

func _next_button_pressed() -> void:
	_play_click_sound()
	total_frames = current_part.sprite_frames.get_frame_count("default")
	if current_part.frame >= (total_frames-1):
		current_part.frame = 0
	else:
		current_part.frame += 1

func _save_button_pressed() -> void:
	_play_click_sound()
	monster_design.reparent(subviewport)
	monster_design.position = Vector2(250.0, 250.0)
	await RenderingServer.frame_post_draw
	subviewport.get_texture().get_image().save_png("res://assets/created_monsters/monster.png")
	monster_design.reparent(get_tree().root)
	monster_design.position = Vector2(640.0, 360.0)

func _antenna_button_pressed() ->  void:
	_play_click_sound()
	current_state = State.ANTENNA

func _body_button_pressed() -> void:
	_play_click_sound()
	current_state = State.BODY

func _arms_button_pressed() -> void:
	_play_click_sound()
	current_state = State.ARMS

func _legs_button_pressed() -> void:
	_play_click_sound()
	current_state = State.LEGS


func _on_request(_from_username: String, _info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	chat_suggestions_feed.message_text = _args
	chat_suggestions_feed.from_user = _from_username
	SignalBus.new_suggestion_added.emit()
	
	request_dictionary[_args] = _from_username
	
	# Add User to Game as a Candy Corn
	var new_character = chat_character.instantiate()
	var random_x : float = randf_range(32.0, 1248.0)
	new_character.position = Vector2(random_x, 688)
	add_child(new_character)
	new_character.label.text = _from_username
	
	if request_dictionary.size() >= 5 and shuffle_requests.disabled == true:
		shuffle_requests.disabled = false
	print("Requests: " + str(request_dictionary))

func _on_join(_from_username: String, _info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	var new_character = chat_character.instantiate()
	var random_x : float = randf_range(32.0, 1248.0)
	new_character.position = Vector2(random_x, 688)
	add_child(new_character)
	new_character.label.text = _from_username

func _play_click_sound() -> void:
	ui_click.play()


func _on_got_it_pressed() -> void:
	_title_slide_up()
	_slide_down()
	_play_click_sound()
	
	

func _slide_from_left(target) -> void:
	var tween : Tween
	var target_position: float = 0.0
	var duration : float = 0.75
	
	if tween : tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(target, "offset_transform_position:x", target_position, duration)

func _slide_from_right(target) -> void:
	var tween : Tween
	var target_position: float = 0.0
	var duration : float = 0.75
	
	if tween : tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(target, "offset_transform_position:x", target_position, duration)

func _title_slide_up() -> void:
	var tween: Tween
	var target_position: float = -500.0
	var duration : float = 0.75
	
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(game_title, "position:y", target_position, duration)

func _slide_down() -> void:
	var tween : Tween
	
	var target_position: float = 750.0
	var duration : float =  0.75
	
	if tween : tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(game_intro, "position:y", target_position, duration)
	
	tween.finished.connect(func() -> void:
		_slide_from_left(chat_instructions)
		_slide_from_right(suggestions_feed_and_button_container)
	)

func _instructions_slide_left(target) -> void:
	var tween : Tween
	var target_position: float = -1000.0
	var duration : float = 0.75
	
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(target, "offset_transform_position:x", target_position, duration)

func _feed_slide_right(target) -> void:
	var tween : Tween
	var target_position: float = 1500.0
	var duration : float = 0.75
	
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(target, "offset_transform_position:x", target_position, duration)
	tween.finished.connect(func() -> void:
		_deck_building_start()
	)

func _start_game() -> void:
	# Slide Out Deck Shuffling Container
	var cards_in_hand = get_tree().get_nodes_in_group("hand")
	for card in cards_in_hand:
		card.reparent(player_hand_container)
	SignalBus.cards_in_hand.emit()
	_slide_out(player_hand, 1050.0)
	# Slide in the following:
	# Color Palette, Drawing Container, Parts Selector, Tween Chosen Cards to side.
	_slide_in(paint, Vector2(252.0, 360.0))
	_slide_in(monster_drawing_panel, Vector2(450.0, 52.0))
	_slide_in(body_part_selector, Vector2(925.0, 50.0))
	pass

func _slide_out(target, target_position) -> void:
	var tween : Tween
	var duration : float = 0.75
	if tween : tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(target, "position:x", target_position, duration)

func _slide_in(target, target_position) -> void:
	var tween : Tween
	var duration : float = 0.75
	if tween : tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(target, "position", target_position, duration)

func _deck_building_start() -> void:
	var shuffle = deck_shuffle.instantiate()
	ui_container.add_child(shuffle)
	
	shuffle.spawn_cards(request_dictionary)
	print("Requests: " + str(request_dictionary))

func _on_shuffle_requests_pressed() -> void:
	# Cue the instructions and suggestions feed to slide out of view.
	_instructions_slide_left(chat_instructions)
	_feed_slide_right(suggestions_feed_and_button_container)
	
	_play_click_sound()
	
	#if deck_build_begin == true:
	#
		#var shuffle = deck_shuffle.instantiate()
		#ui_container.add_child(shuffle)
		#
		#shuffle.spawn_cards(request_dictionary)
	
	#var chosen_entries : Array = []
	#var available_card_prompts : int = 3
	#
	#for prompt in available_card_prompts:
		#var submission : PackedStringArray
		#var user : String
		#submission = request_dictionary.keys().pick_random()
		#user = request_dictionary[submission]
		#chosen_entries.append([submission, user])
		#request_dictionary.erase(submission)
	#
		#var new_card : ChatSuggestedCard = chat_suggestion_card.instantiate()
		#prompt_cards.add_child(new_card)
		#new_card.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN + Control.SIZE_EXPAND
		#new_card.set_details("".join(submission), user)
		#
		#
	#print("Chosen Entries: " + str(chosen_entries))
