# Check the case of the first parameter and return the second parameter in that same case
def match_case(original, shifted)
	if original =~ /[A-Z]/
		return shifted.upcase
	else
		return shifted
	end
end

# Wrap around index in case parameter causes shift > 25 or less than 0
def index_adjust(new_index)
	if new_index > 25
		return new_index - 26
	elsif new_index < 0
		return new_index + 26
	else
		return new_index
	end 
end

alphabet = ('a'..'z').to_a
index = 0

puts "Enter a message to encrypt:"

# split user input into character array
user_text = gets.chomp.split("")

puts "Enter the shift factor:"

shift = gets.chomp.to_i

user_text.map! {|l|
	if l =~ /\w/

		# call index_adjust to shift the index variable to the user specified amount
		index = index_adjust(alphabet.index(l.downcase) + shift)

		# send the original letter to match_case to set proper case for the shifted letter
		# and update the case corrected shifted letter to the array
		match_case(l, alphabet[index])
	else
		# Keep the original character if non-alpha (punctuation or space)
		l
	end
}

# rejoin updated array to string for screen output
puts user_text.join
