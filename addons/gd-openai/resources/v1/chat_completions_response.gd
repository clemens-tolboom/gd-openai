class_name ChatCompletionResponse

extends ResponseData

var id
var object
var created
var model
var usage
var choices

func _init():
	super._init()
	__class_name = "ChatCompletionResponse"
