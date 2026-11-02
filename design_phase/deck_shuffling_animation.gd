extends Control
class_name DeckShufflingAnimation

@onready var h_flow_container: HFlowContainer = %HFlowContainer
@onready var card_shuffle: AudioStreamPlayer = %CardShuffle
@onready var card_converge: AudioStreamPlayer = %CardConverge
@onready var card_dealt: AudioStreamPlayer = %CardDealt
@onready var card_flipped: AudioStreamPlayer = %CardFlipped

var game_card : PackedScene = preload("res://design_phase/chat_suggested_card.tscn")

func _ready() -> void:
	SignalBus.cards_in_hand.connect(func() -> void:
		queue_free()
	)

func spawn_cards(card_list : Dictionary) -> void:
	var list_length = card_list.size()
	for card in card_list:
		var new_card = game_card.instantiate()
		h_flow_container.add_child(new_card)
		new_card.add_to_group("cards")
		
		var submission 
		var user 
		
		submission = card
		print("Submission: " + str("".join(submission)))
		user = card_list[card]
		new_card.suggestion.text = "".join(submission)
		new_card.username.text = user
		list_length -= 1
		await get_tree().create_timer(0.25).timeout
	
	if list_length == 0:
		await get_tree().create_timer(0.5).timeout
		converge_cards()

func converge_cards() -> void:
	var all_cards = get_tree().get_nodes_in_group("cards")
	var number_of_cards = all_cards.size()
	card_converge.play()
	for card in all_cards:
		card.combine_into_deck()
		number_of_cards -= 1
	
	if number_of_cards == 0:
		await get_tree().create_timer(2.0).timeout
		shuffle_animation()

func shuffle_animation() -> void:
	# Take card from back, tween up, change z-index, move to front of node tree, move down, repeat a handful of times.
	var all_cards = get_tree().get_nodes_in_group("cards")
	var shuffles : int = 5
	if not all_cards.is_empty():
		for shuffle in shuffles:
			card_shuffle.pitch_scale = randf_range(0.8, 1.2)
			card_shuffle.play()
			var back_card = all_cards[-1]
			var height : float = 200.0
			var origin : float = 310.0
			var duration : float = 0.15
			var tween : Tween
			back_card.z_index = -20
			if tween : tween.kill()
			tween = create_tween()
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			tween.tween_property(back_card, "position:y", height, duration)
			tween.tween_property(back_card, "z_index", 20, duration)
			tween.tween_property(back_card, "position:y", origin, duration)
			await get_tree().create_timer(0.5).timeout
			if shuffle >= 4:
				await get_tree().create_timer(0.15).timeout
				deal_three_cards()

func deal_three_cards() -> void:
	# Choose Three Random Cards, Remove From Deck, Deal Them Out, Flip Cards One By One. Deal Fourth Card as special "Hidden Object"
	var all_cards = get_tree().get_nodes_in_group("cards")
	var cards_to_choose : int = 3
	var target : Vector2 = Vector2(1.0, 450.0)
	var x_offset : float = 274.0
	var duration : float = 0.5
	card_dealt.play()
	for card in cards_to_choose:
		var chosen_card = all_cards.pick_random()
		chosen_card.remove_from_group("cards")
		chosen_card.add_to_group("hand")
		all_cards.erase(chosen_card)
		print("Chose Card: " + str(chosen_card.suggestion))
		var tween : Tween
		if tween : tween.kill()
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(chosen_card, "position", Vector2(target.x + (card * x_offset), target.y), duration )
		if card >= 2:
			await get_tree().create_timer(1.0).timeout
			GameController.secret_card = all_cards.pick_random()
			var audience = get_tree().get_nodes_in_group("audience")
			var pick = audience.pick_random()
			pick.has_disguise = true
			print("Secret Card: " + str(GameController.secret_card))
			reveal_hand()

func reveal_hand() -> void:
	var hand = get_tree().get_nodes_in_group("hand")
	card_flipped.play()
	for card in hand:
		card.animation_player.play("card_flip")
		card.current_state = card.State.FACE_UP
	await get_tree().create_timer(0.75).timeout
	SignalBus.cards_dealt.emit()
