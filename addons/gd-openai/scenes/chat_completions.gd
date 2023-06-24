extends Control

const chat_path:StringName = "user://openai/chat/completions/"
const file_pattern:StringName = "res-{0}.tres"

@onready var connector:OpenAiApiRequest = $OpenAiApiRequest

@export var request:ChatCompletionRequest

var response:ChatCompletionResponse = ChatCompletionResponse.new()

@export var show_system :bool = false
@onready var system:TextEdit = %System

@export var show_assistant :bool = false
@onready var assistant:TextEdit = %Assistant

@export var show_user :bool = false
@onready var user:TextEdit = %User

@onready var resp_text = %Response

signal submit_request(req, res)

func setup_resources():
	var dir = DirAccess.open("user://")
	dir.make_dir_recursive("openai/chat/completions")

func _ready():
	setup_resources()

	system.placeholder_text = "This is the insturction about the behaviour of the Chat AI."
	system.visible = show_system

	assistant.placeholder_text = "This is the context or previous generated text."
	assistant.visible = show_assistant
	
	user.placeholder_text = "Instruct the Chat AI with your wishes."
	user.visible = show_user

	reset()

func _on_clear_pressed():
	reset()

func reset():
	if show_system:
		system.text = request.system
	if show_assistant:
		assistant.text = request.assistant
	if show_user:
		user.text = request.user

func update_request():
	if show_system:
		request.system = system.text
	if show_assistant:
		request.assistant = assistant.text
	if show_user:
		request.user = user.text

func _on_submit_pressed():
	update_request()
	connector.do_post(request, response)
#	submit_request.emit(request, ChatCompletionResponse.new())

func _on_open_ai_api_request_data_received(data):
	print("received")
	response = data
	resp_text.text = data.choices[0].message.content
	var file_path = chat_path + file_pattern.format([12])
	var error:int = ResourceSaver.save(response, file_path)
	if not error == OK:
		printt("Unable to save models")


func _on_open_ai_api_request_error_response(error):
	print(error)