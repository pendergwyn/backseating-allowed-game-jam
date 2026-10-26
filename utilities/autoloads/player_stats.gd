extends Node

#region Monster Stats and Info

var max_stat_level : int = 12
var scare_stat : int = 0
var stealth_stat : int = 0
var speed_stat : int = 0
var strength_stat : int = 0
var discovered_level : int = 0
var max_discovered : int = 20

var candy_total : int = 0

var outfit_score : int = 0

#endregion

#region Player Info

const ACTIONS_PER_TURN : int = 2

var money : int = 0
var stat_points : int = 0

var saved_monster : Texture2D

#endregion

#region Chat Stats

var chat_stat_points: int = 0

#endregion
