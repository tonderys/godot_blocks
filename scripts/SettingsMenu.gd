extends Node2D	

var mute_on = preload("res://icons/mute_on.png")
var mute_off = preload("res://icons/mute_off.png")

func update_settings():
	var data = Settings.data
	if data.nickname != "":
		get_node("MenuButtons/SetNickname/DefaultNickname").text = data.nickname
		get_node("MenuButtons/SetNickname/Background/insert name/name").text = data.nickname
	get_node("MenuButtons/BelowDestroyed/RemainingsBehavior").text = "Fall" if data.fall else "Destroy"
	get_node("MenuButtons/Blocks/Color").text = "Color" if data.color else "Grey"
	get_node("Background").reload()
	get_node("MenuButtons/SetNickname/Background").reload()
	get_node("MenuButtons/Sound/Intensity").value = data.volume
	get_node("MenuButtons/Sound/value").text = \
		"%s"%[0 if data.muted else int(100 + (data.volume * 1.25))]
	get_node("MenuButtons/Sound/mute").icon = mute_on if data.muted else mute_off
	Settings.save_file()
		
func _ready():
	if(Settings.data):
		update_settings()
		
func _change_color():
	Settings.change_color()
	update_settings()

func _set_nickname():
	get_node("MenuButtons/SetNickname/Background").visible = true

func _change_remainings():
	Settings.change_remainings()
	update_settings()

func _toggle_mute():
	Settings.toggle_mute()
	update_settings()

func _set_volume(value):
	Settings.set_volume(value)
	update_settings();
	Sounds.get_node("addSquare").play()

func _change_nickname():
	get_node("MenuButtons/SetNickname/Background").visible = false
	Settings.data.nickname = get_node("MenuButtons/SetNickname/Background/insert name/name").text
	update_settings()
