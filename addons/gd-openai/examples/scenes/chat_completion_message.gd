extends HBoxContainer

@export var message:ChatCompletionRequestMessage:
	set(v):
		message = v
		update_values()

func update_values():
	$Role.text = message.role
	$Content.text = message.content
	if is_node_ready():
		$Content.grab_focus()


func _on_role_item_selected(index):
	message.role = $Role.text

	if message.role == 'system':
		$Content.placeholder_text = "Your instructions about the behaviour of the Chat AI."

	if message.role == 'assistant':
		$Content.placeholder_text = "This is the context or previous generated text."

	if message.role == 'user':
		$Content.placeholder_text = "Instruct the Chat AI with your wishes or your previous one."


func _on_content_text_changed():
	message.content = $Content.text
