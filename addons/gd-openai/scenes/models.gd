extends Control

const models_path:StringName = "user://openai/models.tres"

@export var request:ModelsRequest

@onready var connector:OpenAiApiRequest = $OpenAiApiRequest

@onready var list:ItemList = $VBoxContainer/ScrollContainer/ItemList

var response:ModelsResponse

func setup_resources():
	if FileAccess.file_exists(models_path):
		response = ResourceLoader.load(models_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		DirAccess.make_dir_absolute("user://openai")

func _ready():
	setup_resources()

	if response == null:
		fetch_models()
	else:
		fill_list()

func fill_list():
	list.clear()
	for item in response.data:
		var line = "{id} ({object})".format(item)
		if not item.root == item.id:
			line += " < {root}"
		list.add_item(line)
	list.sort_items_by_text()


func _on_open_ai_api_request_data_received(data):
	response = data

	var error:int = ResourceSaver.save(response, models_path)
	if not error == OK:
		printt("Unable to save models")

	fill_list()

func _on_open_ai_api_request_error_response(error):
	print(error)

func fetch_models():
	connector.do_get(request, ModelsResponse.new())

func _on_refresh_pressed():
	fetch_models()
