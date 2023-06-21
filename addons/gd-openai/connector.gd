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

func _init():
	request_completed.connect(_http_request_completed)


## Make is possible to switch versioning.[br]
const ApiVersion:StringName = "v1/"

## Hold client request Response Resource.
##
## This should be ResponseData extended class.
var _resp


## Fixme: why is this needed?
## When @export values in RequestData it seems not to work anymore
func _copy_props(req, resp):
	resp.path = req.path
	resp.version = req.version

# ===== DRY alert ====
# do_get and do_post only differ in method and yes/no body.

## Do a GET request to the 
func do_get(req, resp):
	_copy_props(req, resp)
	_resp = resp
	var args:Dictionary = req.build_request(BaseURL)
	printt("do_get", args['uri'])

	var has_error = request( \
		args['uri'], \
		args["headers"], \
		HTTPClient.METHOD_GET, \
	)

	if has_error != OK:
		push_error("An error occurred in the HTTP request.")
	return has_error

func do_post(req, resp):
#	_copy_props(req, resp)
	_resp = resp
	var args:Dictionary = req.build_request(BaseURL)
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
	data_received.emit(_resp)
	_resp = null

