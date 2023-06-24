class_name ImagesGenerationsRequest

extends RequestData

const GroupId:String = "images"

## A text description of the desired image(s).[br]
##[br]
## The maximum length is 1000 characters.[br]
##[br]
## @required
@export_multiline var prompt:String = ""

## Number of response images[br]
##
## @optional
@export var n:int = 1:
	set(value):
		if value > 0:
			n = value
		else:
			n = 1

const sizes:Array[String] = ["256x256", "512x512", "1024x1024"]

## The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024
##
## @options

@export_enum("256x256", "512x512", "1024x1024") var size:String = "1024x1024":
	set(value):
		if sizes.has(value):
			size = value
		else:
			print_debug("invalid size %s" % value)
			size = "1024x1024"


const response_formats:Array[String] = ["url", "b64_json"]

## The format in which the generated images are returned. Must be one of url or b64_json.
##
@export_enum("url", "b64_json") var response_format:String = "url":
	set(value):
		if response_formats.has(value):
			response_format = value
		else:
			print_debug("invalid response_format '{0}'. Use one of {1}".format([value, response_formats]))

func _init():
	super._init()

	path = "images/generations"


func build_request(root:String) -> Dictionary:
	var req:Dictionary = super.build_request(root)

	req["body"]["prompt"] = prompt
	req["body"]["n"] = n
	req["body"]["size"] = size
	req["body"]["response_format"] = response_format

	return req
