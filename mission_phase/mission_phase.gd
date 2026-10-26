extends Node2D
class_name MissionPhase

enum State {
	PLAYER,
	DETECTION,
	ENEMY,
}
var current_state : State = State.PLAYER

@onready var current_turn_label: RichTextLabel = %CurrentTurnLabel
@onready var player_monster: Sprite2D = %PlayerMonster


var player_actions : Array[String] = [
	"move",
	"hide",
	"gather",
	"throw",
]

var action_number : int = 0
var position_to_move_to : Vector2 = Vector2(0.0, 0.0)
var player_position_offset : Vector2 = Vector2(16.0, 16.0)
var player_is_moving : bool = false
var move_duration : float = 0.5
var tween: Tween


func _ready() -> void:
	current_turn_label.text = "Current Phase: " + str(State.keys()[current_state])
	var board_nodes = get_tree().get_nodes_in_group("board_space")
	for space : TextureButton in board_nodes:
		space.pressed.connect(_choose_space_to_move.bind(space.position))
	

func _process(_delta: float) -> void:
	if action_number >= PlayerStats.ACTIONS_PER_TURN:
		_state_transition(State.ENEMY)
	
	match current_state:
		
		State.PLAYER:
			## Player Turn
			if player_is_moving:
				_move_action()
			
		State.DETECTION:
			pass
			
		State.ENEMY:
			## Enemy Turn
			# Loop Through Enemies/Cameras and have them resolve their movement/actions.
			var enemies = get_tree().get_nodes_in_group("enemy")
			for enemy in enemies:
				enemy.turn_actions()
			
			_state_transition(State.PLAYER)
			

func _state_transition(new_state : State) -> void:
	current_state = new_state
	current_turn_label.text = "Current Phase: " + str(State.keys()[current_state])
	
	match current_state:
		State.PLAYER:
			action_number = 0
		State.ENEMY:
			pass

func _choose_space_to_move(new_position : Vector2) -> void:
	position_to_move_to = new_position
	player_is_moving = true
	

func _move_action() -> void:
	print("Player Position: " + str(player_monster.position))
	print("New Pos: " + str(position_to_move_to))
	#player_monster.position = position_to_move_to + player_position_offset
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property(player_monster, "position", position_to_move_to + player_position_offset, move_duration)
	player_is_moving = false
	tween.finished.connect(func() -> void:
		action_number += 1
	)
	

func _on_move_button_pressed() -> void:
	print("Choose Location to Move To")
	# Enable or Disable Buttons Depending on Which are within range
