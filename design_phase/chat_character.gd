extends Node2D
class_name ChatCharacter

enum State { 
	IDLE,
	HOP
}

var current_state = State.IDLE

@onready var label: Label = %Label
@onready var timer: Timer = %Timer
@onready var disguise: Sprite2D = %Disguise
@onready var area_2d: Area2D = %Area2D
@onready var nice_find: GPUParticles2D = %NiceFind
@onready var found_hidden_card: AudioStreamPlayer = %FoundHiddenCard

var disguise_texture : Texture2D = preload("res://assets/chat_characters/chat_candy_corn_disguise.png")
var has_disguise : bool = false
var direction : Array = [-1, 1]
var move_direction : int

func _ready() -> void:
	
	timer.start()
	
	timer.timeout.connect(_switch_states)

func _process(_delta: float) -> void:
	if has_disguise == true:
		disguise.texture = disguise_texture
		area_2d.monitorable = true
		area_2d.monitoring = true
	
	if position.x >= DisplayServer.screen_get_size().x:
		position.x = 0.0
	if position.x < 0.0:
		position.x = DisplayServer.screen_get_size().x
	
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
		


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if has_disguise == true and event.is_action_pressed("left_mouse"):
		SignalBus.hidden_card_found.emit()
		nice_find.emitting = true
		found_hidden_card.play()
		print("Found")
