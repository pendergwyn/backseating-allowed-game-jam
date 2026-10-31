extends Control
class_name ChatSuggestedCard

@onready var suggestion: RichTextLabel = %Suggestion
@onready var username: RichTextLabel = %Username
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var card_back: PanelContainer = %CardBack

var tween : Tween
var starting_position: Vector2

func _ready() -> void:
	scale = Vector2(1.0, 1.0)
	offset_transform_position = Vector2(1360.0, 800.0)
	
	card_back.mouse_entered.connect(_mouse_hover)
	card_back.mouse_exited.connect(_mouse_exited)
	print("start pos: " + str(starting_position))
	
	_enter_tween()

func _process(delta: float) -> void:
	pass

func _mouse_hover() -> void:
	_floating_tween()
	print("hover")

func _mouse_exited() -> void:
	_stop_floating_tween()

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


func _on_card_back_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		print("flip card!")
		animation_player.play("card_flip")
