extends Node2D

const Scoreboard = preload("res://scripts/Scoreboard.gd")
var scoreboard = Scoreboard.new()

func _ready():
	get_node("UI/insert name/name").text = scoreboard.score_data.recent_name

func name_focus_entered():
	get_node("UI/insert name/name").text = ""

func submit_pressed():
	scoreboard.save(get_node("UI/insert name/name").text, Global.score)
	get_tree().change_scene("res://scenes/Summary.tscn")
