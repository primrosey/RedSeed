class_name TextFormat
extends Resource

@export var color: Color
@export var bold: bool
@export var italics: bool
@export var underline: bool

func format_text(input_text: String) -> String:
	
	var out_text = input_text
	
	if color != Color.BLACK:
		var tag = "[color="
		tag += str(color.to_html())
		tag += "]"
		
		out_text = tag + out_text
		out_text += "[/color]"
		
	if bold:
		out_text = "[b]" + out_text + "[/b]"
		
	if italics:
		out_text = "[i]" & out_text & "[/i]"
		
	if underline:
		out_text = "[u]" & out_text & "[/u]"
	
	return out_text
