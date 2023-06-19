extends Control

@export var request:ChatCompletionRequest

@export var show_system :bool = false
@onready var system:TextEdit = $VBoxContainer/System

@export var show_assistant :bool = false
@onready var assistant:TextEdit = $VBoxContainer/Assistant

@export var show_user :bool = false
@onready var user:TextEdit = $VBoxContainer/User

signal submit_request(req, res)

func _ready():
	system.placeholder_text = "This is the insturction about the behaviour of the Chat AI."
	system.visible = show_system

	assistant.placeholder_text = "This is the context or previous generated text."
	assistant.visible = show_assistant
	
	user.placeholder_text = "Instruct the Chat AI with your wishes."
	user.visible = show_user

	reset()

func _on_clear_pressed():
	reset()

func reset():
	if show_system:
		system.text = request.system
	if show_assistant:
		assistant.text = request.assistant
	if show_user:
		user.text = request.user

func update_request():
	if show_system:
		request.system = system.text
	if show_assistant:
		request.assistant = assistant.text
	if show_user:
		request.user = user.text

func _on_submit_pressed():
	update_request()

	submit_request.emit(request, ChatCompletionResponse.new())
