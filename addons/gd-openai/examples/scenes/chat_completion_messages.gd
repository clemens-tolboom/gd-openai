class_name OpenAiChatExample extends VBoxContainer

const CHAT_COMPLETION_MESSAGE = preload("res://addons/gd-openai/examples/scenes/chat_completion_message.tscn")

## List of messages to send to the API.
@export var messages:Array[ChatCompletionRequestMessage] = []:
	set(v):
		messages = v

## The UI list.
@onready var list = %List


func _ready() -> void:
	update_messages()


## Updates the UI.
func update_messages() -> void:
	printt(list.get_child_count(), "->", messages.size())
	for c in list.get_children():
		list.remove_child(c)
		c.queue_free()

	for m in messages:
		var message = CHAT_COMPLETION_MESSAGE.instantiate()
		message.message = m
		list.add_child(message)


## Adds new message to send to the API.
func _on_add_pressed() -> void:
	var r:ChatCompletionRequestMessage = ChatCompletionRequestMessage.new()
	r.role = "user"
	messages.push_back(r)
	update_messages()
