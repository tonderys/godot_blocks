extends Node2D

const settings_file_path = "user://settings.res"
var settings_file = File.new()

var data = {"nickname": "",
			"volume": 100,
			"color": true,
			"fall": true}

func _save_file():
	settings_file.open(settings_file_path, File.WRITE)
	settings_file.store_var(data)
	settings_file.close()
	
func _read_file():
	settings_file.open(settings_file_path, File.READ)
	data = settings_file.get_var()
	settings_file.close()
	
func update_settings():
	if data.nickname != "":
		get_node("MenuButtons/SetNickname/DefaultNickname").text = data.nickname
		get_node("MenuButtons/SetNickname/Background/insert name/name").text = data.nickname
	get_node("MenuButtons/BelowDestroyed/RemainingsBehavior").text = "Fall" if data.fall else "Destroy"
	get_node("MenuButtons/Blocks/Color").text = "Color" if data.color else "Grey"
	get_node("Background").reload()
	get_node("MenuButtons/SetNickname/Background").reload()
	get_node("MenuButtons/Sound/Intensity").value = data.volume
	
	if data.volume > 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), data.volume / 10)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	_save_file()

func _init():
	if not settings_file.file_exists(settings_file_path):
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

func _set_volume(value):
	data.volume = value
	update_settings();

func _change_nickname():
	get_node("MenuButtons/SetNickname/Background").visible = false
	data.nickname = get_node("MenuButtons/SetNickname/Background/insert name/name").text
	update_settings()
