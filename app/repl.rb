repl do
	def to_shell(s)
		$gtk.write_file 'mygame/app/repl.out', s.to_s
	end
	result = methods
	to_shell(result)
end
