extends Control
class_name DeckShufflingAnimation

@onready var h_flow_container: HFlowContainer = %HFlowContainer
@onready var card_spawn_timer: Timer = %CardSpawnTimer

var game_card : PackedScene = preload("res://design_phase/chat_suggested_card.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		var new_card = game_card.instantiate()
		h_flow_container.add_child(new_card)
		new_card.add_to_group("cards")
	if event.is_action_pressed("right_mouse"):
		converge_cards()

func spawn_cards(card_list : Dictionary) -> void:
	
	for card in card_list:
		var new_card = game_card.instantiate()
		h_flow_container.add_child(new_card)
		new_card.add_to_group("cards")
		
		var submission 
		var user 
		submission = card_list.get(card)
		user = card_list[card]
		
		new_card.set_details(submission, user)
		
		await get_tree().create_timer(0.25).timeout

func converge_cards() -> void:
	var all_cards = get_tree().get_nodes_in_group("cards")
	for card in all_cards:
		card.combine_into_deck()
