extends HBoxContainer
class_name StarRatings

@onready var star_one: TextureRect = %StarOne
@onready var star_two: TextureRect = %StarTwo
@onready var star_three: TextureRect = %StarThree

var rating : int = 0

func _process(delta: float) -> void:
	match rating:
		1:
			star_one.texture.region = Rect2(32.0, 0.0, 32.0, 32.0)
		2:
			star_one.texture.region = Rect2(32.0, 0.0, 32.0, 32.0)
			star_two.texture.region = Rect2(32.0, 0.0, 32.0, 32.0)
		3:
			star_one.texture.region = Rect2(32.0, 0.0, 32.0, 32.0)
			star_two.texture.region = Rect2(32.0, 0.0, 32.0, 32.0)
			star_three.texture.region = Rect2(32.0, 0.0, 32.0, 32.0)
