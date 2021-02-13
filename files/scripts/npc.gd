extends MeshInstance

var rng

var adj = ["authorized", "unauthorized", "valid", "invalid", "secure", "stable", "unstable", "sentient", "genetic", "aperiodic", "periodic", "deterministic", "emergent", "nested", "recursive", "chaotic"]
var subj = ["probe", "entity", "user", "automata", "operator", "node", "system", "agent", "specimen", "procedure", "observer", "layer", "environment", "biome", "sector", "root", "condition"]
var verb = ["fixed", "detected", "connected", "transmitted", "corrected", "simulated", "scanned", "encoded", "decoded", "spawned", "serialized", "categorized", "inherited", "converted"]
var adverb = ["correctly", "incorrectly", "normally", "abnormally", "urgently", "randomly", "eventually", "rarely", "frequently", "regularly", "occasionally"]

var message
var label
var timer

func _ready():
	rng = RandomNumberGenerator.new()
	label = $label
	timer = $timer
	label.hide()

func _set_up(var rng_seed):
	rng.seed = rng_seed
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
