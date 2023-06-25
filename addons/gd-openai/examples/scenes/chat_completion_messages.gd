class_name OpenAiChatExample extends VBoxContainer

const Message = preload("res://addons/gd-openai/examples/scenes/chat_completion_message.tscn")

@export var messages:Array[ChatCompletionRequestMessage] = []:
	set(v):
		messages = v

@onready var list = %List


func _ready():
	update_messages()


func update_messages():
	printt(list.get_child_count(), "->", messages.size())
	for c in list.get_children():
		list.remove_child(c)
		c.queue_free()

	for m in messages:
		var message = Message.instantiate()
		message.message = m
		list.add_child(message)


func _on_add_pressed():
	var r:ChatCompletionRequestMessage = ChatCompletionRequestMessage.new()
	r.role = "user"
	messages.push_back(r)
	update_messages()
