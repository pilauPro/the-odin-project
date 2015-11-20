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

		index = alphabet.index(l.downcase)

		index = index_adjust(index + shift)

		coded_text.push(match_case(l, alphabet[index]))
	else
		coded_text.push(l)
	end
end

puts coded_text.join("")

