require("mklk.tweaks.todo-float").setup({
	target_file = "ToDo.md",
	global_file = "~/data/second-brain/ToDo.md",
})
require("mklk.tweaks.py-extract-definitions").setup({
	def_keymap = "<leader>ped",
	doc_keymap = "<leader>peD",
})
require("mklk.tweaks.buffer-persistence")
require("mklk.tweaks.comfy-numbers").setup({
	up_key = "k",
	down_key = "j",
})
