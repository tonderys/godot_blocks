extends Node2D

const settings_file_path = "user://settings.res"

var data = {"nickname": "",
			"volume": 0,
			"muted": false,
			"color": true,
			"fall": true}

func log_data():
	print("vvvvvvvvvvvvvvvvvvvvvvvvvv")
	print("data:")
	if(data):
		print("\tnickname: \"", data.nickname, "\"")
		print("\tvolume: ", data.volume)
		print("\t", "muted" if data.muted else "not muted")
		print("\t", "color" if data.color else "grey")
		print("\t", "fall" if data.fall else "destroy")
	else:
		print("\tempty")
	print("^^^^^^^^^^^^^^^^^^^^^^^^^^")

func save_file():
	var settings_file = FileAccess.open(settings_file_path, FileAccess.WRITE)
	settings_file.store_var(data)
	settings_file.close()
	
func _read_file():
	var settings_file = FileAccess.open(settings_file_path, FileAccess.READ)
	data = settings_file.get_var()
	settings_file.close()
	
func _init():
	print("Initializing settings")
	if not FileAccess.file_exists(settings_file_path):
		save_file()
	else:
		_read_file()

func _change_color():
	data.color = !data.color

func _change_remainings():
	data.fall = !data.fall

func _toggle_mute():
	data.muted = !data.muted

func _set_volume(value):
	data.volume = value
	Sounds.get_node("addSquare").play()
