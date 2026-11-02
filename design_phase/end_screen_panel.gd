extends PanelContainer
class_name GameOverScoring

const ONE_STAR = 150
const TWO_STAR = 300
const THREE_STAR = 500

@onready var star_ratings_1: StarRatings = %StarRatings1
@onready var prompt_1_score_number_label: Label = %Prompt1ScoreNumberLabel
@onready var star_ratings_2: StarRatings = %StarRatings2
@onready var prompt_2_score_number_label: Label = %Prompt2ScoreNumberLabel
@onready var star_ratings_3: StarRatings = %StarRatings3
@onready var prompt_3_score_number_label: Label = %Prompt3ScoreNumberLabel
@onready var star_ratings_4: StarRatings = %StarRatings4
@onready var hidden_score_number_label: Label = %HiddenScoreNumberLabel
@onready var bonus_score_number: Label = %BonusScoreNumber
@onready var final_score_label_2: Label = %FinalScoreLabel2

var prompt1_rating : int = 0
var prompt2_rating : int = 0
var prompt3_rating : int = 0
var hidden_rating : int = 0
var prompt1_score : int = 0
var prompt2_score : int = 0
var prompt3_score : int = 0
var hidden_score : int = 0
var bonus_score : int = 0
var final_score : int = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		prompt1_rating += 1
		_update_score()
		_total_score()

func _update_score() -> void:
	star_ratings_1.rating = prompt1_rating
	prompt_1_score_number_label.text = str(prompt1_score)
	
	star_ratings_2.rating = prompt2_rating
	prompt_2_score_number_label.text = str(prompt2_score)
	
	star_ratings_3.rating = prompt3_rating
	prompt_3_score_number_label.text = str(prompt3_score)
	
	star_ratings_4.rating = hidden_rating
	hidden_score_number_label.text = str(hidden_score)
	

func _total_score() -> void:
	final_score += prompt1_score + prompt2_score + prompt3_score + hidden_score + bonus_score
	
	
