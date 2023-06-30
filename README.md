# GD Script OpenAI (0.3.0)

Interfacing with the [OpenAI API's](https://platform.openai.com/overview) using their **[API Key](https://platform.openai.com/account/api-keys)**

With the `gd-openai` addon you can quickly create scenes interacting with the
[API](https://platform.openai.com/docs/api-reference) of OpenAI. See the examples below.

Download the ZIP file from GitHub or install through the AssetLib when available.

## Examples

### Chat

![Chat example](https://raw.githubusercontent.com/clemens-tolboom/gd-openai/main/addons/gd-openai/assets/chat.png)

### Image generation

![Image generation example](https://raw.githubusercontent.com/clemens-tolboom/gd-openai/main/addons/gd-openai/assets/image-generation.png)

### Browse the saved resources

![Saved resources](https://raw.githubusercontent.com/clemens-tolboom/gd-openai/main/addons/gd-openai/assets/image-browser.png)

## User Data

The settings file `open_ai_user_data.tres` and all requests and responses are saved in `user://`.

The settings file for security reasons as it may not become part of the build.

The requests and responses for browsing back possibilities.

## What calls are available?

- [/v1/chat/completions](https://platform.openai.com/docs/api-reference/chat)
  to mimic ChatGPT sessions. **Note**: only model, system, assistent, user are available.
- [/v1/models](https://platform.openai.com/docs/api-reference/models) to find available models.
- [/v1/images/generations](https://platform.openai.com/docs/api-reference/images) for generating inspiring images.

## API Key

The tool needs an [API key](https://platform.openai.com/account/api-keys)
from your OpenAI account.

Run `addons/gd-openai/user_data.tscn` to set your API key.

Then run one of the examples to validate your key is correct.
- `addons/gd-openai/examples/scenes/models.tscn`
- `addons/gd-openai/examples/scenes/image_strip.tscn`
- `addons/gd-openai/examples/scenes/chat_completions.tscn`

The key is stored in `Project > Open User Data Folder`.

## Examples

The are some examples available to list the `models`, start a `chat/completions`
or fiddle with `images/generations`.

## Building a scene

You need to add 3 parts to your scene:

### OpenAiApiRequest

As a child in your tree.

```gdscript
@onready var openai_api_request:OpenAiApiRequest = $OpenAiApiRequest

func _ready():
	# Connect openai_api_request signals through the UI or code
	openai_api_request.connect("data_received", _on_open_ai_api_request_data_received)
	openai_api_request.connect("error_response", _on_open_ai_api_request_error_response)

func _on_open_ai_api_request_data_received(data):
	response = data

func _on_open_ai_api_request_error_response(error):
	print(error)
```

### RequestData sub-class

RequestData sub-class like ModelsRequest, ChatCompletionsRequest, ImageGenerationsRequest, etc

```gdscript
@export var request:ChatCompletionsRequest
```

Then set it's value through the UI.

### ResponseData sub-class

ResponseData sub-class like ModelsResponse.

```gdscript
var response:ChatCompletionsResponse = ChatCompletionsResponse.new()
```

### Request/response

Initiate the call ie by a Button click

```
openai_api_request.do_post(request, response)
```

and wait for one of the two signals to appear.

## Roadmap

- Add **all** properties to [/v1/chat/completions](https://platform.openai.com/docs/api-reference/chat)
- [/v1/models/{model}](https://platform.openai.com/docs/api-reference/models/retrieve)
- your wishes / PRs / support

## References

- [OpenAI API's](https://platform.openai.com/overview)
- [API Key](https://platform.openai.com/account/api-keys)
- [API](https://platform.openai.com/docs/api-reference)

### Some other implementations

- [godot-openai](https://github.com/Buri/godot-openai)
- [GPTIntegration](https://github.com/finepointcgi/Godot-Open-AI-GPT-Integration)
- [GodotGPT](https://github.com/rrbenx/GodotGPT)
