extends Node2D

@onready var yellow_piece : Sprite2D = $YellowPiece
@export var game_spaces : Array[Spot]
@export var chest_boxes : Array[PackedScene]
@export var chance_boxes : Array[PackedScene]
var place : int = 0
var number_of_spaces : int
@onready var dice := $Dice
@onready var timer := $Timer
@onready var canvas_layer: CanvasLayer = $CanvasLayer
var score : int = 0
@onready var score_label: Label = $"CanvasLayer/Score Label"

func _ready() -> void:
	number_of_spaces = game_spaces.size()
	Events.question_box_gone.connect(on_question_box_gone)
	Events.chance_box_gone.connect(on_chance_box_gone)
	Events.chest_box_gone.connect(on_chest_box_gone)


func _on_dice_dice_has_rolled(roll: Variant) -> void:
		#This line is for testing. Uncomment it and change roll to whatever you need.
	#roll = 1
	while roll != 0:
		await (move(place))
		place += 1
		roll -= 1
		#this check tells us if we've stopped
	if roll == 0:
		await(move(place))
		if game_spaces[place].direction == Direction.WhichWay.BACK:
			#we want to go backwards
			var two_spaces_back = place - 2
			while place != two_spaces_back:
				place -=1
				await (move(place))
		if game_spaces[place].direction == Direction.WhichWay.FORWARD:
			#we want to go forwards
			var two_spaces_forwards = place + 3
			while place != two_spaces_forwards:
				await (move(place))
				place += 1
		if game_spaces[place].direction == Direction.WhichWay.QUESTION:
			#load
			var question_box = preload("res://questionbox.tscn")
			#instance
			var question = question_box.instantiate()
			#add
			canvas_layer.add_child(question)
			#position
			dice.can_click = false
		if game_spaces[place].direction == Direction.WhichWay.CHEST:
			chest_boxes.shuffle()
			#load
			var chest_box = chest_boxes.front()
			#instance
			var chest = chest_box.instantiate()
			#add
			canvas_layer.add_child(chest)
			#position
			dice.can_click = false
		if game_spaces[place].direction == Direction.WhichWay.CHANCE:
			chance_boxes.shuffle()
			#load
			var chance_box = chance_boxes.front()
			#instance
			var chance = chance_box.instantiate()
			#add
			canvas_layer.add_child(chance)
			#position
			dice.can_click = false
		if game_spaces[place].direction == Direction.WhichWay.JAIL:
			#load
			var question_box = preload("res://jail.tscn")
			#instance
			var question = question_box.instantiate()
			#add
			canvas_layer.add_child(question)
			#position
			dice.can_click = false

func move(place) -> void:
	var tween = create_tween()
	tween.tween_property(yellow_piece, "position", game_spaces[place].position, 1)
	timer.start()
	await timer.timeout
	dice.can_click = true

func on_question_box_gone(point):
	if point == true:
		score = score + 1
		score_label.text = str(score)
	await get_tree().process_frame
	dice.can_click = true

func on_chance_box_gone():
	await get_tree().process_frame
	dice.can_click = true

func on_chest_box_gone():
	await get_tree().process_frame
	dice.can_click = true
