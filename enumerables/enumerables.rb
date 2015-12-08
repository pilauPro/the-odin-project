module Enumberable
	def my_each(arr)
		i = 0
		(arr.size).times{
			yield arr[i]
			i+=1
		}
		arr
	end
	def my_each_with_index(arr)
		i = 0
		(arr.size).times{
			yield arr[i],i
			i+=1
		}
		arr
	end
	def my_select(arr)
		arr2 = []
		i = 0
		(arr.size).times{
			arr2 << arr[i] if yield(arr[i])
			i+= 1
		}
		arr2
	end
end

include Enumberable

arr = [1,2,3,4,5]

my_each(arr){|x| puts "element: #{x}"}
my_each_with_index(arr){|item,index| puts "item: #{item} index: #{index}"}
arr2 = my_select(arr){|x| x%2 == 0}
puts arr2.inspect
