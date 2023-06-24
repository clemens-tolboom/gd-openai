## Request resource for OpenAI API.[br]
##[br]
## This is the base request
class_name RequestData extends Resource

## Path for the API key and other fields.
const data_resource = "user://open_ai_user_data.tres"


## OpenAI API specific version
@export var version:StringName = 'v1'

## OpenAI API specific path.
@export var path:StringName = ""

## Placeholder for content.[br]
##[br]
## We can add items to the dictionary in child Resources.
var content:Dictionary = {}

## Required headers.
var headers:Dictionary = {
	"Authorization": "",
	"Content-Type": "application/json"
}

## Do not export this as it then become part of the Resource.
var _api_key:String = ""


## Make sure the authorization is set.
func _init():
	set_authorization()


## Prepare for the API key.
func set_authorization():
	if _api_key == "":
		get_api_key()
	assert(not _api_key == "", "No API key found")

	headers["Authorization"] = "Bearer %s" % _api_key

## Helper to key the API key.[br]
func get_api_key():
	var r:OpenAiUserData = ResourceLoader.load(data_resource)
	assert(not r == null, "File '%s'not found or wrong content" % data_resource)
	_api_key = r.api_key

## Build the API path.
func get_uri(root:String):
	return "{root}/{version}/{path}".format({
		"root": root,
		"version": version,
		"path": path,
	})

## Make strings of the header key, value pairs.
func fold_key_value(d:Dictionary) -> PackedStringArray:
	var r:PackedStringArray = []
	for k in d:
		r.append("{key}: {value}".format({"key": k, "value": d[k]}))
	return r

## Builds a dictionary with the needed keys.[br]
func build_request(root:String) -> Dictionary:
	return {
		"body": content,
		"headers": fold_key_value(headers),
		"uri": get_uri(root)
	}