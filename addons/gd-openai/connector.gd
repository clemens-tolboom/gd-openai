## OpenAI API Request Handler
class_name OpenAiApiRequest extends HTTPRequest

## Notify for errors trying to serve the request.
signal error_response(error:Dictionary)

## Notify for the received data.
##
## This should be ResponseData extended class.
signal data_received(data)

## Hold
var resource:OpenAiUserData

## The Root for API requests
const BaseURL:StringName = "https://api.openai.com"

## The root director for saved requests and responses.
const SaveResourcePath:StringName = "user://openai/data/"

## Initialize the request completion.
func _init():
	request_completed.connect(_http_request_completed)


## Make is possible to switch versioning.[br]
##[br]
## FIXME: version is also in the request.
const ApiVersion:StringName = "v1/"

## Hold client request Response Resource.
##
## This should be ResponseData extended class.
var _resp


## Copy the request base values into the response[br]
##[br]
## We now have the request version and path into the response.[br]
## This could help later when path and/or version changes.
func _copy_props(req, resp):
	resp.path = req.path
	resp.version = req.version

func prepare_request(req,resp):
	_copy_props(req, resp)
	_resp = resp
	# Before requesting we save the request.
	save_request(req)

	return req.build_request(BaseURL)

# ===== DRY alert ====
# do_get and do_post only differ in method and yes/no body.

## Do a GET request.[br]
func do_get(req, resp):
	var args:Dictionary = prepare_request(req, resp)
	printt("do_get", args['uri'])

	var has_error = request( \
		args['uri'], \
		args["headers"], \
		HTTPClient.METHOD_GET, \
	)

	if has_error != OK:
		push_error("An error occurred in the HTTP request.")
	return has_error

## Do a POST request.[br]
func do_post(req, resp):
	var args:Dictionary = prepare_request(req, resp)
	printt(args['uri'], args["body"])

	var has_error = request( \
		args['uri'], \
		args["headers"], \
		HTTPClient.METHOD_POST, \
		JSON.stringify(args["body"])
	)

	if has_error != OK:
		push_error("An error occurred in the HTTP request.")
	return has_error

## Process the response and emits appropiate signal.
func _http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	printt(result, response_code)#, headers)#, body)

	if not result == OK:
		print(response_code)
		return

	var content:String = body.get_string_from_utf8()

	var json = JSON.new()
	json.parse(content)
	var response = json.get_data()
#	print(response)

	if response_code >= 400:
		printt("ERROR", response_code, response["error"])
		error_response.emit(response["error"])
		return

	_resp.from_dict(response)
	save_response(_resp)
	data_received.emit(_resp)
	_resp = null

## Saves the resource on it's request path and timebased sub dirs combined.
func save_resource(item, name:String):
	var dir_tree = SaveResourcePath + item.path + '/' + dir_timestamp()
	DirAccess.make_dir_recursive_absolute(dir_tree)

	var item_path = dir_tree + name + '-' + timestamp() + '.tres'

	var error:int = ResourceSaver.save(item, item_path)
	if not error == OK:
		printt("Unable to save resource", item_path, item.get_class())

## Saves the request.
func save_request(req):
	printt("save_request", req.path)
	save_resource(req, 'request')

## Saves the response.
func save_response(resp):
	printt("save_response", resp.path)
	save_resource(resp, 'response')

## Returns year/month/day string with 4 digits year and 2 digits month and day.
func dir_timestamp() -> String:
	return "{year}/{month}/{day}/".format(Time.get_date_dict_from_system())

## Generates a filename compatible timestamp with only numbers and letter T.
func timestamp() -> String:
	return Time.get_datetime_string_from_system().replace('-', '').replace(':', '')
