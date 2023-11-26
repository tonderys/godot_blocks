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
	var name = get_node("UI/insert name/name").text
	scoreboard.save(name, Global.score)
	SilentWolf.Scores.persist_score(name, Global.score)
	if get_tree().change_scene("res://scenes/Summary.tscn") != OK:
		print("Can't open summary scene")
