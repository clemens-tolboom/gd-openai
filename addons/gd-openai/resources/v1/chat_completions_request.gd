## Chat completion continues the given prompts
##
## There are 4 prompt types: user, assistant, system and function[br]
## NOTE: [code]function[/code] is not implemented.
class_name ChatCompletionRequest

extends RequestData

## This is part of the GPT models
const GroupId:String = "gpt"


## Indicates the model to use.
##
## See [ModelsRequest] and [ModelsResponse] for list of sub models.
@export var model:String = "gpt-3.5-turbo"

## List of messages like system, assistant or user.
@export var messages:Array[ChatCompletionRequestMessage] = []

## Initialize class.
##
## The API subpath will be prefixed by [var version]
func _init() -> void:
	super._init()
	path = "chat/completions"


func add_message(d:Dictionary, message_type:StringName, content:String) -> void:
	if not d['body'].has('messages'):
		d["body"]["messages"] = []
	d["body"]["messages"].push_back({"role": message_type, "content": content})


func build_request(root:String) -> Dictionary:
	var res:Dictionary = super.build_request(root)
	res["body"]["model"] = model

	for m in messages:
		add_message(res, m.role, m.content)

	return res

