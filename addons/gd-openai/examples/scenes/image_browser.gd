class_name DemoImageBrowser extends Control

@onready var images_control:FlowContainer = $ScrollContainer/FlowContainer

func _ready():
	var files:Array = GdOpenAiUtils.get_all_files("user://openai/data/images/generations")

	files = filter_files('response', files)
	printt("Processing", files.size(), "files")
	for f in files:
		var data = read_file(f)
		update_images(data)

func filter_files(file_prefix:String, list:Array) -> Array:
	return list.filter(func(file_path:String): return file_path.rsplit("/",true, 1)[1].begins_with(file_prefix))

func read_file(file:String):
	var file_name:String = file.rsplit("/",true, 1)[1]
	if file_name.begins_with("request"):
		return null

#	print(file)
	var res:ImagesGenerationsResponse = ResourceLoader.load(file, "ChatCompletionResponse")
	return res.data

func update_images(items, clear:bool = false):
	for d in items:
		var b64:String = d.b64_json
		var t:ImageTexture = GdOpenAiUtils.base64_to_texture(b64)
		if not t == null:
			var tb = TextureButton.new()
			tb.texture_normal = t
			images_control.add_child(tb)
