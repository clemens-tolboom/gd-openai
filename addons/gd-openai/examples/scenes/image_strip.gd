## Image strip asking for images based on give prompt.
extends Control

## Connector to OpenAI's API
@onready var openai_api_request:OpenAiApiRequest = $OpenAiApiRequest

## Request for image generation
##[br]
## N: 3[br]
## Size: 256x256[br]
## Response Format: b64_json
@export var request:ImagesGenerationsRequest


## Peer of the request above[br]
var response:ImagesGenerationsResponse = ImagesGenerationsResponse.new()

@onready var list = $VBoxContainer/GridContainer

func _ready():
	# Connect openai_api_request signals through the UI or code
	openai_api_request.connect("data_received", _on_open_ai_api_request_data_received)
	openai_api_request.connect("error_response", _on_open_ai_api_request_error_response)


func _on_open_ai_api_request_data_received(data):
	response = data

	for d in response.data:
		var b64:String = d.b64_json
		var t:ImageTexture = GdOpenAiUtils.base64_to_texture(b64)
		if not t == null:
			var tb = TextureButton.new()
			tb.texture_normal = t
			list.add_child(tb)


func _on_open_ai_api_request_error_response(error):
	print(error)


func _on_button_pressed():
	var prompt:String = %TextEdit.text.strip_edges()
	if prompt == "":
		print("Empty prompt")
		return
	request.prompt = prompt
	openai_api_request.do_post(request, response)
