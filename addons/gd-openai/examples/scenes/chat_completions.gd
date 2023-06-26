extends Control

const chat_path:StringName = "user://openai/chat/completions/"
const file_pattern:StringName = "res-{0}.tres"

@onready var connector:OpenAiApiRequest = $OpenAiApiRequest

@export var request:ChatCompletionRequest

@onready var default_request:ChatCompletionRequest
var response:ChatCompletionResponse = ChatCompletionResponse.new()

@onready var messages = %Messages


signal response_received(req:ChatCompletionRequest, res:ChatCompletionResponse)

func _ready():
	default_request = request.duplicate(true)
	messages.messages = request.messages
	messages.update_messages()

func _on_clear_pressed():
	request.messages = default_request.messages
	messages.messages = request.messages
	messages.update_messages()

func update_request():
	printt(request.messages, messages.messages)
	request.messages = []
	var index:int = 0
	for m in messages.messages:
		index += 1
		var msg:ChatCompletionRequestMessage = m
		if not msg.content.strip_edges() == "":
			printt("Adding", index, "\n", m.content)
			request.messages.push_back(m)
		else:
			printt("Skipping", index)
	messages.messages = request.messages


func _on_submit_pressed():
	update_request()
	if not request.messages.size() > 0:
		print_debug("No messages to process")
		return
	connector.do_post(request, response)


func _on_open_ai_api_request_data_received(data):
	printt("received", data.choices)
	response = data

	for c in response.choices:
		var r:ChatCompletionRequestMessage = ChatCompletionRequestMessage.new()
		r.role = c.message.role
		r.content = c.message.content
		request.messages.push_back(r)
		messages.update_messages()

	response_received.emit(request, response)

func _on_open_ai_api_request_error_response(error):
	print(error)
