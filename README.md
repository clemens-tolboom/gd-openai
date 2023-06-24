# GD Script OpenAI

Interfacing with the [OpenAI API's](https://platform.openai.com/overview)

With this tools addon you can quickly create scenes interacting with the
[API](https://platform.openai.com/docs/api-reference) of OpenAI.

Download the ZIP file from GitHub or install through the AssetLib when available.

## What calls are available?

- [/v1/chat/completions](https://platform.openai.com/docs/api-reference/chat)
  to mimic ChatGPT sessions. **Note**: only model, system, assistent, user in single mode are available.
- [/v1/models](https://platform.openai.com/docs/api-reference/models) to find available models.
- [/v1/images/generations](https://platform.openai.com/docs/api-reference/images) for generating inspiring images.

## API Key

The tool needs an [API key](https://platform.openai.com/account/api-keys)
from your OpenAI account.

**Copy** the `open_ai_user_data.tres` from the examples dir to your project root.

Then open it and replace the `API Key` field with your OpenAI API Key.

Then **move** the file out of your project to the game data directory using the menu `Project > Open User Data Folder.

You must move it to make sure not to expose your API Key to the world.

## Examples

The are some examples available to list the `models`, start a `chat/completions`
or fiddle with `images/generations`.

## Building a scene

You need to add 3 parts to your scene:

## OpenAiApiRequest

As a child in your tree.

```gdscript
@ready var openai_api_request:OpenAiApiRequest = $OpenAiApiRequest

func _ready():
	# Connect openai_api_request signals true UI or code
```

## RequestData sub-class

RequestData sub-class like ModelsRequest, ChatCompletionsRequest, ImageGenerationsRequest, etc

```gdscript
@export var request:ChatCompletionsRequest
```

Then set it's value through the UI.

## ResponseData sub-class

ResponseData sub-class like ModelsResponse.

```gdscript
var response:ChatCompletionsResponse = ChatCompletionsResponse.new()
```

## Request/response

Initiate the call ie by a Button click

```
connector.do_post(request, response)
```

and wait for one of the two signals to appear.

## Roadmap

- Fix list of prompts by roles on [/v1/chat/completions](https://platform.openai.com/docs/api-reference/chat)
- Add **all** properties to [/v1/chat/completions](https://platform.openai.com/docs/api-reference/chat)
- [/v1/models/{model}](https://platform.openai.com/docs/api-reference/models/retrieve)
- you wishes / PRs / support

## References

- [godot-openai](https://github.com/Buri/godot-openai)
- [GPTIntegration](https://github.com/finepointcgi/Godot-Open-AI-GPT-Integration)
- [GodotGPT](https://github.com/rrbenx/GodotGPT)
