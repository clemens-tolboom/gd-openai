class_name GdOpenAiUtils extends RefCounted

static func base64_to_texture(b64_json:String) -> ImageTexture:
	var img = Marshalls.base64_to_raw(b64_json)
	var i:Image = Image.new()
	var error = i.load_png_from_buffer(img)

	if not error == OK:
		printt(error, "image2texture", "Error loading image")
		return null

	var texture = ImageTexture.create_from_image(i)
	return texture

## Get all files given path.[br]
##[br]
## This follow the whole subtree.
static func get_all_files(path, files = []):
	var dirAccess:DirAccess = DirAccess.open(path)
	for file in dirAccess.get_files():
		files.append(dirAccess.get_current_dir().path_join(file))
	var dirs = dirAccess.get_directories()
	for dir in dirs:
		get_all_files(dirAccess.get_current_dir().path_join(dir), files)
	return files
