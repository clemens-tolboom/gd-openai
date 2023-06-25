## Chat completion continues the given prompts[br]
##[br]
## There are 4 prompt types: user, assistant, system and function[br]
## Of there [code]function[/code] is not implemented.
class_name ChatCompletionRequest

extends RequestData

## This is part of the GPT models
const GroupId:String = "gpt"

@export_category("ChatCompletionRequest")

## One of the models of GPT-3[br]
##[br]
## See ModelsRequest and ModelsResponse for list of sub models
@export var model:String = "gpt-3.5-turbo"

@export var messages:Array[ChatCompletionRequestMessage] = []


func _init():
	super._init()
	path = "chat/completions"


func add_message(d:Dictionary, message_type:StringName, content:String):
	if not d['body'].has('messages'):
		d["body"]["messages"] = []
	d["body"]["messages"].push_back({"role": message_type, "content": content})


func build_request(root:String) -> Dictionary:
	var res:Dictionary = super.build_request(root)
	res["body"]["model"] = model

	for m in messages:
		add_message(res, m.role, m.content)

	return res

