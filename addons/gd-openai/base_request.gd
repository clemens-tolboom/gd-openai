extends Control

@export var request:RequestData

func _ready():
	if not request == null:
		build_form()


func build_form():
	var container = VBoxContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)

	add_child(container)

	var props = request.form_fields
	for p in request.get_property_list():
		if p["name"] in props:
			print(p)
			var c = TextEdit.new()
			var _name = p.name
			c.name = _name
			c.text = request[_name]
			c.placeholder_text = "Info about " + p.name
			c.set_anchors_preset(Control.PRESET_FULL_RECT)
			c.size_flags_horizontal |= SIZE_EXPAND_FILL
			c.size_flags_vertical |= Control.SIZE_EXPAND_FILL
			container.add_child(c)

