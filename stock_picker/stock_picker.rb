# Matt Leininger - 11/19/2015

def stock_picker(quotes_array)
	y = 0
	x= 0

	best = nil
	current = 0
	results = []

	(0..quotes_array.size - 2).each do |x|
		(x + 1..quotes_array.size - 1).each do |i|		
			current = quotes_array[x].to_i - quotes_array[i].to_i

			if (best == nil) || (current > best) 
				best = current
				results.clear.push(x,i)
			end
		end
	end
	return results
end


puts "Enter a variable amount of closing stock prices, seperated by commas and/or spaces:"

prices_array = gets.chomp.split(/[, ]/)
prices_array.delete("")



print "#{stock_picker(prices_array)} \n"