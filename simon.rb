letters = %w(a s w d)
sequence = []
did_win = true

while did_win
	sequence << letters.sample
	begin
		system("stty raw -echo")
		puts "CURRENT SEQUENCE = #{sequence}"
		input = []
		while str = STDIN.getc
			input << str
			puts "INPUT: #{strd}\n"
			break if input.size == sequence.size
		end
	ensure
		system("stty -raw echo")
	end

	if input == sequence
		puts "WIN"
	else
		puts "Try again"
		did_win = false
	end
end