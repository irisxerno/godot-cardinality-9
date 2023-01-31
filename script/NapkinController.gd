extends Control


export (PackedScene) var napkin


func reset_cursor():
	$Cursor.position = Vector2(0,0)


func napkin(c):
	var inst = napkin.instance()
	inst.rect_position = $Cursor.position
	inst.modulate = c
	add_child(inst)
	$Cursor.position += Vector2(0,30)
