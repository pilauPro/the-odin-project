def substrings(input, dictionary)
	results = Hash.new(0)
	dictionary.each do |word|
		input.each do |e|
			if e.downcase.include?(word.downcase)
				results[word] += 1
			end
		end
	end
	return results.sort!
end


puts "Enter your dictionary words seperated by comma and/or space:"

dictionary = gets.chomp.split(/[, ]/)
dictionary.delete("")

puts "Enter your word/string to search in dictionary:"

user_input = gets.chomp.split(/[\s+,\.!\?]/)
user_input.delete("")

search_hash = substrings(user_input, dictionary) 

puts search_hash
