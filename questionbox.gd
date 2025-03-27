extends CenterContainer

@export var button_one_is_right : bool 
@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var h_box_container: HBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
var right_or_wrong : bool

func _on_button_pressed() -> void:
	if button_one_is_right:
		label.text = "You bought a new property!"
		h_box_container.hide()
		right_or_wrong = true
	else:
		label.text = "Wrong"
		h_box_container.hide()

func _on_button_2_pressed() -> void:
	if button_one_is_right == false:
		label.text = "Right"
		h_box_container.hide()
	else:
		label.text = "You didn't buy the property."
		h_box_container.hide()
		right_or_wrong = false

func _gui_input(event: InputEvent) -> void:
	if h_box_container.visible == false and Input.is_action_just_pressed("ui_click"):
			Events.emit_signal("question_box_gone", right_or_wrong)
			queue_free()
