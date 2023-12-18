extends Control

class_name LoadingScreen

var next_scene_path: String
var loading_status: int
var progress: Array[float]
var scene_progress: float = 0.0

@onready var progress_bar: TextureProgressBar = %LoadingBar
@onready var text: RichTextLabel = %Text

func _ready() -> void:
	next_scene_path = SaveLoad.next_scene
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(_delta) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	match loading_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("invalid resource, could not load")
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			scene_progress = progress[0] * 50
			progress_bar.value = scene_progress
			text.text = "Loading " + str(progress_bar.value) + "%"
		ResourceLoader.THREAD_LOAD_FAILED:
			print("loading failed")
		ResourceLoader.THREAD_LOAD_LOADED:
			scene_progress = 100
			progress_bar.value = 100
			text.text = "Loading 100%"
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene_path))
