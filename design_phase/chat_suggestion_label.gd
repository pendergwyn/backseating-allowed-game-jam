extends RichTextLabel

var tween : Tween
var tween_duration : float = 0.5
var slide_in_target : float = 0.0
var shift_down_target : float = 34.0
var total_entries : int 

func _ready() -> void:
	offset_transform_position = Vector2(-250.0, 0.0)
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "offset_transform_position:x", slide_in_target, tween_duration)
	
	
	SignalBus.new_suggestion_added.connect(_shift_down)

func _shift_down() -> void:
	#total_entries = get_tree().get_nodes_in_group("entries").size()
	offset_transform_position.y =  -shift_down_target
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "offset_transform_position:y", offset_transform_position.y + shift_down_target, tween_duration)
