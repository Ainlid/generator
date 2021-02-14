extends MeshInstance

var rng

var adj = ["authorized", "unauthorized", "valid", "invalid", "secure", "stable", "unstable", "sentient", "genetic", "aperiodic", "periodic", "deterministic", "emergent", "nested", "recursive", "chaotic"]
var subj = ["probe", "entity", "user", "automata", "operator", "node", "system", "agent", "specimen", "procedure", "observer", "layer", "environment", "biome", "sector", "root", "condition"]
var verb = ["fixed", "detected", "connected", "transmitted", "corrected", "simulated", "scanned", "encoded", "decoded", "spawned", "serialized", "categorized", "inherited", "converted"]
var adverb = ["correctly", "incorrectly", "normally", "abnormally", "urgently", "randomly", "eventually", "rarely", "frequently", "regularly", "occasionally"]

var time = 0.0

var message
var label
var timer

var target

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	time = rng.randf_range(0.0, PI)
	label = $label
	timer = $timer
	label.hide()
	_set_up()

func _set_up():
	subj.shuffle()
	verb.shuffle()
	adj.shuffle()
	adverb.shuffle()
	message = adj[0] + " " + subj[0] + " " + verb[0] + " " + adverb[0] + "."

func _speak():
	label.text = message
	label.show()
	timer.start()

func _speak_over():
	label.hide()

func _process(delta):
	if target != null:
		var pos = target.global_transform.origin
		look_at(pos, Vector3.UP)
	time += delta
	if time > PI:
		time = 0.0
	translation.y = sin(time) / 2.0
