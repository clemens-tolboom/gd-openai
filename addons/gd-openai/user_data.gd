extends Control

@export var user_data:OpenAiUserData

func _ready():
	## Creates file
	var dummy = RequestData.new()
	load_data()

func load_data():
	user_data = ResourceLoader.load(RequestData.CONFIG, 'OpenAiUserData', ResourceLoader.CACHE_MODE_REPLACE)
	%ApiKey.text = user_data.api_key


func _on_button_pressed():
	user_data.api_key = %ApiKey.text
	ResourceSaver.save(user_data, RequestData.CONFIG)
	load_data()

	# FIXME: how to close depending on parent?
	if not get_parent().find_child("OpenAiApiRequest", false) == null:
		queue_free()
	else:
		get_tree().quit()

