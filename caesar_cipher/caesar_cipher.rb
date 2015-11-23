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
coded_text = []

puts "Enter a message to encrypt:"

user_text = gets.chomp.split("")

puts "Enter the shift factor:"

shift = gets.chomp.to_i

user_text.each do |l|
	if l =~ /\w/
		# for each letter in the user string, find it's index in the alphabet array, then
		# pass that index plus the shift factor to the index_adjust function
		index = alphabet.index(l.downcase)

		index = index_adjust(index + shift)

		# send the original letter to match_case to set proper case for the shifted letter
		# and push the case corrected shifted letter to the coded_text array
		coded_text.push(match_case(l, alphabet[index]))
	else
		# If l is not a letter (punctuation or space), simply push it to the coded_text
		# array unaltered
		coded_text.push(l)
	end
end

puts coded_text.join("")

