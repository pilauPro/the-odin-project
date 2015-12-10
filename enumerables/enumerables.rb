module Enumberable
	def my_each(arr)
	    i = 0
	    if block_given?
	        (arr.size).times{
	            yield arr[i]
	            i+= 1
	        }
	        arr
	    end
	end
	def my_each_with_index(arr)
	    i = 0
	    (arr.size).times{
	        yield arr[i],i
	        i+= 1
	    }
	    arr
	end
	def my_select(arr, &block)
	    result = []
	    if block_given?
	        my_each(arr) do |x|
	            result << x if yield(x)
	        end
	        result
	    end
	end
	def my_all?(arr, &block)
	    my_each(arr){|x| return false if !yield(x)}
	    true
	end
	def my_any?(arr, &block)
	    my_each(arr){|x| return true if yield(x)}
	    false
	end
end

include Enumberable

arr = [1,2,3,4,5]

my_each(arr){|x| puts "element: #{x}"}
my_each_with_index(arr){|item,index| puts "item: #{item} index: #{index}"}
arr2 = my_select(arr){|x| x%2 == 0}
puts arr2
puts my_all?(arr){|x| x.class == Fixnum}
