extends PanelContainer

@onready var cost: Label = %Cost
@onready var cost_and_button: HBoxContainer = %CostAndButton
@onready var button: Button = %Button

var modifier: int = 1
const permanent_path: String = "res://Scenes/Permanents/LegendaryPermanents/fitness_guru.tscn"
var index: int = 0

func _ready() -> void:
	var price: float = float(cost.text.replace("$", ""))
	if price > TurnData.money:
		button.disabled = true

func play() -> void:
	if TurnData.double_permanents:
		modifier *= 2
	TurnData.viral_chance += (TurnData.sponsors / (TurnData.money / TurnData.follower_base))

func buy() -> void:
	TurnData.money -= float(cost.text.replace("$", ""))
	change_button()
	TurnData.emit_signal("buy", self.get_parent())
	var index: int = 0
	for permanent in TurnData.permanents:
		if permanent == null:
			TurnData.permanents[index] = permanent_path
			self.index = index
			break
		index += 1

func change_button() -> void:
	cost.text = ""
	button.text = "Delete"
	button.disconnect("pressed", buy)
	button.connect("pressed", Callable(self, "delete").bind(self))

func hide_cost_and_button() -> void:
	cost_and_button.visible = false

func delete(permanent_instance: Node) -> void:
	var index: int = TurnData.permanents.find(permanent_instance.permanent_path)
	if index != -1:
		TurnData.permanents[self.index] = null
		TurnData.emit_signal("delete", self.get_parent())
		permanent_instance.queue_free()
