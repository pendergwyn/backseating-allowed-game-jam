extends Node2D
class_name ChatCharacter

enum State { 
	IDLE,
	HOP
}

var current_state = State.IDLE

@onready var label: Label = %Label
@onready var timer: Timer = %Timer

var direction : Array = [-1, 1]
var move_direction : int

func _ready() -> void:
	timer.start()
	
	timer.timeout.connect(_switch_states)

func _process(_delta: float) -> void:
	
	match current_state:
		State.IDLE:
			if timer.is_stopped():
				timer.start()
		
		State.HOP:
			pass
			

func _hop_animation(_direction : int) -> void:
	var height : float = randf_range(8.0, 48.0)
	var distance : float = randf_range(8.0, 32.0)
	var hop_duration : float = 0.5
	var half_hop_duration : float = hop_duration / 2.0
	var tween : Tween
	if  tween : tween.kill()
	
	print("Height: " + str(height) + " Distance: " + str(distance))
	
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position:x", position.x + (_direction * distance), hop_duration)
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y - height, half_hop_duration)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", position.y, half_hop_duration)
	
	tween.finished.connect(func() -> void:
		timer.wait_time = randf_range(1.0, 4.0)
		current_state = State.IDLE
	)

func _switch_states() -> void:
	match current_state:
		State.IDLE:
			current_state = State.HOP
			move_direction = direction.pick_random()
			_hop_animation(move_direction)
		
