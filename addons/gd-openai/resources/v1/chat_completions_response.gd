class_name ChatCompletionResponse

extends ResponseData

@export var id:String = ""
@export var object: String = ""
@export var created:int
@export var model: String = ""
@export var usage:Dictionary = {}
@export var choices:Array = []

func _init():
	super._init()
	__class_name = "ChatCompletionResponse"
