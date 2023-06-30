## Request resource for OpenAI API.
##
## Base request class taking care settings up the headers.
##[br]
## This needs OpenAiUserData resource. See [constant CONFIG].
class_name RequestData extends Resource

## Path for the API key and other fields.
const CONFIG = "user://open_ai_user_data.tres"

## OpenAI API specific version
var version:StringName = 'v1'

## OpenAI API specific path.
var path:StringName = ""

## Placeholder for content.[br]
##[br]
## We can add items to the dictionary in child Resources.
var content:Dictionary = {}

## Required headers.
var headers:Dictionary = {
	"Authorization": "",
	"Content-Type": "application/json"
}

# Do not export this as it then become part of the resources.

## Secret key for using the OpenAI API.
var _api_key:String = ""


## Make sure the authorization is set.
func _init() -> void:
	set_authorization()


## Prepare for the API key.
func set_authorization() -> void:
	if _api_key == "":
		load_api_key()
	if _api_key == "":
		printerr("No API key found")
		return

	headers["Authorization"] = "Bearer %s" % _api_key


## Helper to key the API key.
func load_api_key() -> void:
	if not FileAccess.file_exists(CONFIG):
		var res:OpenAiUserData = OpenAiUserData.new()
		var err = ResourceSaver.save(res, CONFIG)
		if not err == OK:
			printerr("Failed to create", CONFIG)
			return

	var r:OpenAiUserData = ResourceLoader.load(CONFIG)
	if r == null:
		printerr("File not found", CONFIG)

	assert(not r == null, "File '%s'not found or wrong content" % CONFIG)
	_api_key = r.api_key


## Build the API path.
func get_uri(root:String) -> String:
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


## Builds a dictionary with the needed keys.
func build_request(root:String) -> Dictionary:
	return {
		"body": content,
		"headers": fold_key_value(headers),
		"uri": get_uri(root)
	}
