class_name ResponseData

extends Resource

var __class_name: StringName = "ResponseData"

## Taken from the RequestData instance
var version:StringName = 'v1'

## Taken from the RequestData instance
var path:StringName = ''

var irrelevant_props :Array[String] = [
	"RefCounted", 
	"Resource", 
	"Resource", 
	"resource_local_to_scene", 
	"resource_path", 
	"resource_name", 
	"script",
	"__class_name",
	"irrelevant_props"
]


func from_dict(d:Dictionary):
	printt("from_dict", get_class(), __class_name)
	var missed: Array[String] = []
	var props: Array[Dictionary] = get_property_list()
	
	for p in props:
		var n:String = p["name"]
		if d.has(n):
			self[n] = d[n]
			d.erase(n)
		else:
			if irrelevant_props.find(n) == -1:
				# Bug in Godot?: get_property_list() contains script name.
				if n.ends_with(".gd"):
					continue
				missed.push_back(n)

	printt("Missed properties", missed)
	printt("Missed response properties", d.keys())
