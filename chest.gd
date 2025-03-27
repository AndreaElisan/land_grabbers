extends CenterContainer

@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var h_box_container: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer

func _on_button_pressed() -> void:
		label.text = "You fulfilled the Community Chest!"
		h_box_container.hide()

func _gui_input(event: InputEvent) -> void:
	if h_box_container.visible == false and Input.is_action_just_pressed("ui_click"):
			queue_free()
			Events.emit_signal("chest_box_gone")
