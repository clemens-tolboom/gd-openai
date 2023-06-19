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


# The role of the messages author. One of system, user, assistant, or function.

## System prompt[br]
##[br]
## You can prepare the context for your chat.[br]
## @required
@export_multiline var system:String = ""

## Assistant prompt[br]
##[br]
## This is useful for continuating previous responses.[br]
## @optional
@export_multiline var assistant:String = ""

## User prompt [br]
##[br]
## Tell your story to get a continuation for.[br]
## @required
@export_multiline var user:String = ""

## Not yet implemented[br]
##[br]
## Documentation is currently incomplete.
var function:String = ""

func _init():
	super._init()
	path = "chat/completions"

	form_fields = ["model", "system", "assistant", "user"]

func add_message(d:Dictionary, message_type:StringName, content:String):
	if not d['body'].has('messages'):
		d["body"]["messages"] = []
	d["body"]["messages"].push_back({"role": message_type, "content": content})
	
func build_request(root:String) -> Dictionary:
	var res:Dictionary = super.build_request(root)
	res["body"]["model"] = model
	add_message(res, "system", system)
	if not assistant == "":
		add_message(res, "assistant", assistant)
	add_message(res, "user", user)
	return res
