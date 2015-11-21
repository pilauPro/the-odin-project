def substrings(input, dictionary)
	results = {}
	dictionary.each do |word|
		if input.include?(word)
			if results.has_key?(word)
				results[word] = 2
			else 
				results[word] = 1
			end
		end
	end
	return results
end


puts "Enter your dictionary words seperated by comma and/or space:"

dictionary = gets.chomp.split(/[, ]/)
dictionary.delete("")

puts "Enter your word/string to search in dictionary:"

user_input = gets.chomp.split(/[\s+,\.!\?]/)
user_input.delete("")

puts user_input

# search_hash = substrings(user_input, dictionary) 

# puts search_hash
