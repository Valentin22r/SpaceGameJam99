extends Node3D

# -----------------------------
# CONFIG EXPORT
# -----------------------------
@export var pnj_name: String = "PNJ"
@export var quest_index: int = 0

@export var dialogues_before: Array[String] = []
@export var dialogues_during: Array[String] = []
@export var dialogues_after: Array[String] = []
@export var dialogues_postquest: Array[String] = []   # <-- AJOUT

enum QuestType { NONE, FIND_ITEM, INTERACT_OBJECT }
@export var quest_type: QuestType = QuestType.NONE

@export var target_item_name: String = ""
@export var target_object_path: NodePath

# -----------------------------
# VARIABLES INTERNES
# -----------------------------
var player_in_area := false
var target_object: Node = null
var coin_given = false

var before_index := 0
var during_index := 0
var after_index := 0
var postquest_index := 0

@export var amount = 0
@export var coin_amount = 0

static var quest_state := {}    # { quest_index: {started, completed} }


func _ready():
	$InteractLogo.hide()
	$DialogueBubble.hide()

	if target_object_path != NodePath():
		target_object = get_node(target_object_path)

	if not quest_state.has(quest_index):
		quest_state[quest_index] = {
			"started": false,
			"completed": false
		}


# -----------------------------
# DÉTECTION DU JOUEUR
# -----------------------------
func _on_area_area_entered(area: Area3D) -> void:
	if area.name == "PlayerArea":
		player_in_area = true
		$InteractLogo.show()

func _on_area_area_exited(area: Area3D) -> void:
	if area.name == "PlayerArea":
		player_in_area = false
		$InteractLogo.hide()
		$DialogueBubble.hide()


# -----------------------------
# INPUT (touche E)
# -----------------------------
func _input(event):
	if player_in_area and event.is_action_pressed("interact"):
		interact()


# -----------------------------
# INTERACTION PRINCIPALE
# -----------------------------
func interact():
	var q = quest_state[quest_index]

	# AVANT LA QUÊTE
	if not q["started"]:
		var finished = show_dialogue(dialogues_before, "before")

		if finished:
			start_quest()
		return

	# PENDANT LA QUÊTE
	if q["started"] and not q["completed"]:
		show_dialogue(dialogues_during, "during")
		check_quest_progress()
		return

	# APRÈS LA QUÊTE
	if q["completed"]:
		# FIX : permettre d'atteindre les dialogues post-quest
		if after_index < dialogues_after.size() - 1:
			show_dialogue(dialogues_after, "after")
			if coin_given == false :
				GameData.add_money(coin_amount)
				$CoinAudio.play()
				coin_given = true
			return

		# Sinon → dialogues post-quest
		show_dialogue(dialogues_postquest, "postquest")
		return



# -----------------------------
# AFFICHAGE DES DIALOGUES
# -----------------------------
func show_dialogue(list: Array[String], mode: String) -> bool:
	if list.size() == 0:
		return true

	var index := 0

	match mode:
		"before":
			index = before_index
		"during":
			index = during_index
		"after":
			index = after_index
		"postquest":
			index = postquest_index

	index = clamp(index, 0, list.size() - 1)

	var text := list[index]

	# Ajout : afficher progression pour les quêtes d’objets
	if mode == "during" and quest_type == QuestType.FIND_ITEM:
		var current = PlayerInventory.get_item_count(target_item_name)
		text = text.replace("{current}", str(current))
		text = text.replace("{required}", str(amount))

	$DialogueBubble/DialogueText.text = text
	$DialogueBubble.show()

	var finished := false

	match mode:
		"before":
			if before_index < list.size() - 1:
				before_index += 1
			else:
				finished = true

		"during":
			if during_index < list.size() - 1:
				during_index += 1
			else:
				finished = true

		"after":
			if after_index < list.size() - 1:
				after_index += 1
			else:
				finished = true

		"postquest":
			if postquest_index < list.size() - 1:
				postquest_index += 1
			else:
				finished = true

	return finished


# -----------------------------
# QUÊTES
# -----------------------------
func start_quest():
	var q = quest_state[quest_index]
	q["started"] = true
	quest_state[quest_index] = q

func check_quest_progress():
	match quest_type:
		QuestType.FIND_ITEM:
			if player_has_items(target_item_name, amount):
				complete_quest()

		QuestType.INTERACT_OBJECT:
			if target_object and target_object.get("interacted") == true:
				complete_quest()

func complete_quest():
	var q = quest_state[quest_index]
	q["completed"] = true
	quest_state[quest_index] = q

	$DialogueBubble/DialogueText.text = "Quête terminée !"
	$DialogueBubble.show()


# -----------------------------
# INVENTAIRE (array d'items)
# -----------------------------
func player_has_items(item_name: String, required_amount: int) -> bool:
	return PlayerInventory.get_item_count(item_name) >= required_amount
