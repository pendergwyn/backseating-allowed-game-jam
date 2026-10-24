extends Control
class_name MonsterStats

@onready var monster_name: RichTextLabel = %MonsterName
@onready var scare_skill_meter: ProgressBar = %ScareSkillMeter
@onready var scare_increase_button: Button = %ScareIncreaseButton
@onready var stealth_skill_meter: ProgressBar = %StealthSkillMeter
@onready var stealth_increase_button: Button = %StealthIncreaseButton
@onready var speed_skill_meter: ProgressBar = %SpeedSkillMeter
@onready var speed_increase_button: Button = %SpeedIncreaseButton
@onready var strength_skill_meter: ProgressBar = %StrengthSkillMeter
@onready var strength_increase_button: Button = %StrengthIncreaseButton
@onready var skill_point_label: RichTextLabel = %SkillPointLabel
@onready var chats_points_label: RichTextLabel = %ChatsPointsLabel


func _ready() -> void:
	# Button Signal Connections
	scare_increase_button.pressed.connect(_increase_stat.bind("scare", "player"))
	stealth_increase_button.pressed.connect(_increase_stat.bind("stealth", "player"))
	speed_increase_button.pressed.connect(_increase_stat.bind("speed", "player"))
	strength_increase_button.pressed.connect(_increase_stat.bind("strength", "player"))
	
	#Twitch Command Signals
	TwitchService.instance.add_command("strength", _strength_increase)
	TwitchService.instance.add_command("scare", _scare_increase)
	TwitchService.instance.add_command("stealth", _stealth_increase)
	TwitchService.instance.add_command("speed", _speed_increase)
	
	PlayerStats.stat_points = 3
	PlayerStats.chat_stat_points = 5
	_update_skill_point_label()
	_check_available_stat_points()

func _strength_increase(_from_username: String, _info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	if PlayerStats.chat_stat_points > 0:
		_increase_stat("strength", "chat")

func _scare_increase(_from_username: String, _info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	if PlayerStats.chat_stat_points > 0:
		_increase_stat("scare", "chat")

func _stealth_increase(_from_username: String, _info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	if PlayerStats.chat_stat_points > 0:
		_increase_stat("stealth", "chat")

func _speed_increase(_from_username: String, _info: TwitchCommandInfo, _args: PackedStringArray) -> void:
	if PlayerStats.chat_stat_points > 0:
		_increase_stat("speed", "chat")

func _increase_stat(stat : String, who : String) -> void:
	match stat:
		"scare":
			PlayerStats.scare_stat += 1
			scare_skill_meter.value = PlayerStats.scare_stat
		"stealth":
			PlayerStats.stealth_stat += 1
			stealth_skill_meter.value = PlayerStats.stealth_stat
		"speed":
			PlayerStats.speed_stat += 1
			speed_skill_meter.value = PlayerStats.speed_stat
		"strength":
			PlayerStats.strength_stat += 1
			strength_skill_meter.value = PlayerStats.strength_stat
	
	if who == "player":
		PlayerStats.stat_points -= 1
	elif who == "chat":
		PlayerStats.chat_stat_points -= 1
		
	_update_skill_point_label()
	_check_available_stat_points()

func _update_skill_point_label() -> void:
	skill_point_label.text = "Points Available: " + str(PlayerStats.stat_points)
	chats_points_label.text = "Chats Points Available: " + str(PlayerStats.chat_stat_points)

func _check_available_stat_points() -> void:
	if PlayerStats.stat_points == 0:
		var skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
		for button : Button in skill_buttons:
			button.disabled = true
