## Sub resource for the [ChatCompletionRequest].
##
## Structure for messages in [ChatCompletionRequest].
class_name ChatCompletionRequestMessage extends Resource


##The role of the messages author. One of `system`, `user`, `assistant`, or `function`.
##[br]
##Note: [code]function[/code] is not supported yet.[br]
##[br]
##@required
@export_enum("system", "user", "assistant", "function") var role:String = "user"

## The contents of the message. `content` is required for all messages except assistant messages with function calls.
@export var content:String = ""

## The name of the author of this message. `name` is required if role is `function`, and it should be the name of the function whose response is in the `content`. May contain a-z, A-Z, 0-9, and underscores, with a maximum length of 64 characters.
@export var name:String

## Not supported yet.
var function_call = null
