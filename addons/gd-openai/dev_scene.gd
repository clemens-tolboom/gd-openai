extends Control

@onready
var api_request:OpenAiApiRequest = $OpenAiApiRequest

func _ready():
	pass
#	models_request()
	test_chat_completions()
#	test_image_generation()


func models_request():
	var req:RequestData = ModelsRequest.new()

	api_request.do_get(req, ModelsResponse.new())

func test_chat_completions():
	var req:ChatCompletionRequest = ChatCompletionRequest.new()
	req.system = "You are a child of seven year old. So keep it simple. You must reply in Dutch language."
	req.user = "What is the moon?"
	api_request.do_post(req, ChatCompletionResponse.new())

func test_image_generation():
	var req:ImagesGenerationsRequest = ImagesGenerationsRequest.new()
	req.prompt = "Colorful imaginary drawing of Statue of liberty"
	req.n = 3
	req.size = "256x256"

	# FIXME: Implement ImagesGenerationsRespnse
	api_request.do_post(req, ImagesGenerationsResponse.new())

func _on_open_ai_api_request_error_response(error):
	printt("ERROR", error)


func _on_open_ai_api_request_data_received(resp):
	if resp is ModelsResponse:
		var mr:ModelsResponse = resp
		print(mr.object)
	elif resp is ImagesGenerationsResponse:
		var ig:ImagesGenerationsResponse = resp
		printt(ig)
	elif resp is ChatCompletionResponse:
		var cc:ChatCompletionResponse = resp
		printt(cc.choices[0].message.content)
	else:
		print("Unhandled response", resp.path)


func _on_char_completions_submit_request(req, res):
	api_request.do_post(req, res)
