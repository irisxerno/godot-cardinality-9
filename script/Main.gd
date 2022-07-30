extends Node

func _ready():
	$Table.set_input(false)
	$Tabs.set_input(false)
	
func _on_tab(b):
	if b:
		$Table.set_input(false)
	else:
		$Table.set_input(true)

func _on_GameStartDealer_done():
	$Tabs.show()
	$Tabs.set_input(true)
	$Table.set_input(true)
