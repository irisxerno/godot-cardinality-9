extends Control


signal return_cards
signal add_armory

var selected = false
var frame = 0
var card
var armory
var hack_return_card
var hack_load_card

var armory_scene


func _ready():
	$Flash.modulate = Color(0,0,0,0)
	update()


func _process(delta):
	if frame > 0:
		frame -= 1
		if frame == 0:
			selected = false
			update()
	if hack_return_card:
		emit_signal("return_cards", [hack_return_card])
		hack_return_card = []
	if hack_load_card:
		give_card(hack_load_card)
		hack_load_card = null


func give_card(c):
	clear()
	card = c
	card.face_up = false
	card.update_face()
	card.move_to($Hack.to_global(Vector2(0,0)))
	$Timer.start()


func new_armory(v,s):
	armory = armory_scene.instance()
	armory.position = $Hack2.to_global(Vector2(0,0))
	armory.value = v
	armory.suit = int(s)
	emit_signal("add_armory", armory)


func _on_Timer_timeout():
	$AlphaTween.interpolate_property($Flash, "modulate", Color(1, 1, 1, 1), Color(0, 0, 0, 0), 0.5, Tween.TRANS_LINEAR)
	$AlphaTween.start()
	new_armory(card.value, card.suit)


func clear():
	$Timer.stop()
	if card:
		hack_return_card = card
		card = null
	if armory:
		armory.kill()
		armory = null


func update():
	var a = 0.5
	if selected:
		if armory:
			a = 1
		$Background.modulate = Color(1, 1, 1, a)
	else:
		$Background.modulate = Color(0, 0, 0, a)
	visible = true


func update_armories():
	if armory:
		armory.move_to($Hack2.to_global(Vector2(0,0)))
	if card:
		card.move_to($Hack.to_global(Vector2(0,0)))

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if selected:
			clear()
		selected = !selected
		update()


func _input(event):
	if event is InputEventMouseButton and event.pressed and not Rect2(Vector2(), $hitbox.rect_size).has_point($hitbox.get_local_mouse_position()) and selected:
		frame = 1
		update()

