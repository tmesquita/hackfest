require "arduino_firmata"

@arduino = ArduinoFirmata.connect
puts "firmata version #{@arduino.version}"

@random = Random.new

colors = {red: 12, green: 11, blue: 10, yellow: 9}
letters = %w(a s w d)
letter_colors = {'a' => colors[:red], 's' => colors[:green], 'w' => colors[:blue], 'd' => colors[:yellow]}
sequence = []
did_win = true


sleep 0.5
@arduino.digital_write 12, true
@arduino.digital_write 11, true
@arduino.digital_write 10, true
@arduino.digital_write 9, true
sleep 1.5
@arduino.digital_write 12, false
@arduino.digital_write 11, false
@arduino.digital_write 10, false
@arduino.digital_write 9, false

def blink_color(color)
	@arduino.digital_write color, true
	sleep 0.5
	@arduino.digital_write color, false
end

while did_win
	sequence << letters[@random.rand(100) % 4]
	begin
		puts "CURRENT SEQUENCE = #{sequence}"
		sequence.each do |e|
			sleep 1
			blink_color(letter_colors[e])
		end
		system("stty raw -echo")
		input = []
		while str = STDIN.getc
			input << str
			puts "INPUT: #{str}\n"
			break if input.size == sequence.size
		end
	ensure
		system("stty -raw echo")
	end

	if input == sequence
		puts "WIN"
	else
		(0..5).each do |i|
			@arduino.digital_write 12, true
			@arduino.digital_write 11, true
			@arduino.digital_write 10, true
			@arduino.digital_write 9, true
			sleep 0.5
			@arduino.digital_write 12, false
			@arduino.digital_write 11, false
			@arduino.digital_write 10, false
			@arduino.digital_write 9, false
			sleep 0.5
		end
		puts "Try again"
		did_win = false
	end
end


