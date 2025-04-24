extends Node2D

const settings_file_path = "user://settings.res"

var mute_on = preload("res://icons/mute_on.png")
var mute_off = preload("res://icons/mute_off.png")

var data = {"nickname": "",
			"volume": 0,
			"muted": false,
			"color": true,
			"fall": true}

func _save_file():
	var settings_file = FileAccess.open(settings_file_path, FileAccess.WRITE)
	settings_file.store_var(data)
	settings_file.close()
	
func _read_file():
	var settings_file = FileAccess.open(settings_file_path, FileAccess.READ)
	data = settings_file.get_var()
	settings_file.close()
	
func update_settings():
	if self.data.nickname != "":
		get_node("MenuButtons/SetNickname/DefaultNickname").text = data.nickname
		get_node("MenuButtons/SetNickname/Background/insert name/name").text = data.nickname
	get_node("MenuButtons/BelowDestroyed/RemainingsBehavior").text = "Fall" if data.fall else "Destroy"
	get_node("MenuButtons/Blocks/Color").text = "Color" if data.color else "Grey"
	get_node("Background").reload()
	get_node("MenuButtons/SetNickname/Background").reload()
	get_node("MenuButtons/Sound/Intensity").value = data.volume
	get_node("MenuButtons/Sound/value").text = \
		"%s"%[0 if data.muted else int(100 + (data.volume * 1.25))]
	
	if data.volume == -80 or data.muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), data.volume / 4)
	get_node("MenuButtons/Sound/mute").icon = mute_on if data.muted else mute_off
	_save_file()

func _init():
	if not FileAccess.file_exists(settings_file_path):
		_save_file()
	else:
		_read_file()
		
func _ready():
	update_settings()
		
func _change_color():
	data.color = !data.color
	update_settings()

func _set_nickname():
	get_node("MenuButtons/SetNickname/Background").visible = true

func _change_remainings():
	data.fall = !data.fall
	update_settings()

func _toggle_mute():
	data.muted = !data.muted
	update_settings()

func _set_volume(value):
	data.volume = value
	update_settings();
	Sounds.get_node("addSquare").play()

func _change_nickname():
	get_node("MenuButtons/SetNickname/Background").visible = false
	data.nickname = get_node("MenuButtons/SetNickname/Background/insert name/name").text
	update_settings()
