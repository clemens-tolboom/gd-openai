class_name RequestData

extends Resource

const data_resource = "user://open_ai_user_data.tres"

## OpenAI API specific version[br]
##[br]
## FIXME: should we export this?
var version:StringName = 'v1'

## OpenAI API specific path[br]
##[br]
## FIXME: should we export this?
var path:StringName = ""

## Content is a dictionary (sure?)[br]
##
## We can add items to the dictionary in child classes
var content:Dictionary = {}

var headers:Dictionary = {
	"Authorization": "",
	"Content-Type": "application/json"
}

var form_fields = []

var _api_key:String = ""

func _init():
	set_authorization()

func set_authorization():
	if _api_key == "":
		get_api_key()
	assert(not _api_key == "", "No API key found")

	headers["Authorization"] = "Bearer %s" % _api_key


func get_api_key():
	var r:OpenAiUserData = ResourceLoader.load(data_resource)
	assert(not r == null, "File '%s'not found or wrong content" % data_resource)
	_api_key = r.api_key


func get_uri(root:String):
	return "{root}/{version}/{path}".format({
		"root": root,
		"version": version,
		"path": path,
	})

func fold_key_value(d:Dictionary) -> PackedStringArray:
	var r:PackedStringArray = []
	for k in d:
		r.append("{key}: {value}".format({"key": k, "value": d[k]}))
	return r

func build_request(root:String) -> Dictionary:
	return {
		"body": content,
		"headers": fold_key_value(headers),
		"uri": get_uri(root)
	}

func build_form(parent):
	for f in form_fields:
		pass
