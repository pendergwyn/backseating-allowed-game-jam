extends Control
class_name ChatSuggestedCard

enum State {
	FACE_UP,
	FACE_DOWN,
}

var current_state : State = State.FACE_UP

@onready var suggestion: RichTextLabel = %Suggestion
@onready var username: RichTextLabel = %Username
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var card_back: PanelContainer = %CardBack
@onready var card_front: PanelContainer = %CardFront

var tween : Tween
var starting_position: Vector2

func _ready() -> void:
	scale = Vector2(1.0, 1.0)
	offset_transform_position = Vector2(1360.0, 800.0)
	card_front.visible = true
	card_back.visible = false
	card_front.mouse_filter = Control.MOUSE_FILTER_STOP
	card_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	card_front.mouse_entered.connect(_mouse_hover)
	card_front.mouse_exited.connect(_mouse_exited)
	card_back.mouse_entered.connect(_mouse_hover)
	card_back.mouse_exited.connect(_mouse_exited)
	print("start pos: " + str(starting_position))
	
	_enter_tween()

func _process(delta: float) -> void:
	match current_state:
		State.FACE_UP:
			card_front.visible = true
			card_back.visible = false
		State.FACE_DOWN:
			card_front.visible = false
			card_back.visible = true

func _mouse_hover() -> void:
	_floating_tween()
	print("hover")

func _mouse_exited() -> void:
	_stop_floating_tween()
	print("exit")

func _enter_tween() -> void:
	if tween : tween.kill()
	var target : Vector2 = Vector2(0.0, 0.0)
	var flight_duration : float = 0.5
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "offset_transform_position", target, flight_duration)
	

func _floating_tween() -> void:
	# Floating Tween
	var position_target : float = 5.0
	var tween_duration : float = 0.75
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", position.y + (-1.0 * position_target), tween_duration)
	tween.tween_property(self, "position:y", position.y + position_target, tween_duration)

func _stop_floating_tween() -> void:
	var tween_duration : float = 0.5
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", starting_position.y, tween_duration)

func set_details(submission: String, twitch_name: String) -> void:
	suggestion.text = "'" + submission + "'"
	username.text = "from: " + twitch_name

func combine_into_deck() -> void:
	animation_player.play("card_flip_front")
	current_state = State.FACE_DOWN
	await get_tree().create_timer(0.75).timeout
	var tween : Tween
	if tween : tween.kill()
	var target : Vector2 = Vector2(274.0, 310.0)
	var flight_duration : float = 0.5
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "position", target, flight_duration)

func shuffle() -> void:
	pass
	

func _on_card_back_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		
		animation_player.play("card_flip")
		current_state = State.FACE_UP
		card_front.mouse_filter = Control.MOUSE_FILTER_STOP
		card_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
func _on_card_front_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		
		animation_player.play_backwards("card_flip_front")
		current_state = State.FACE_DOWN
		card_front.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card_back.mouse_filter = Control.MOUSE_FILTER_STOP
