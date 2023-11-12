extends Node2D

const Scoreboard = preload("res://scripts/Scoreboard.gd")
var scoreboard = Scoreboard.new()

func _ready():
	var nick = Settings.data.nickname
	if nick == "":
		nick = scoreboard.score_data.get_recent_name()
	get_node("UI/insert name/name").text = nick
	get_node("UI/Score").text = "Score:%s" % Global.score

func enable_submit():
	get_node("UI/Submit").disabled = false

func name_focus_entered():
	get_node("UI/insert name/name").text = ""

func submit_pressed():
	scoreboard.save(get_node("UI/insert name/name").text, Global.score)
	get_tree().change_scene("res://scenes/Summary.tscn")
