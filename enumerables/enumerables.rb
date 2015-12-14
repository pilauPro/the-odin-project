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
	def my_select(arr)
	    result = []
        my_each(arr){|x| result << x if yield(x)}
        result
	end
	def my_all?(arr)
	    my_each(arr){|x| return false if !yield(x)}
	    true
	end
	def my_any?(arr)
	    my_each(arr){|x| return true if yield(x)}
	    false
	end
	def my_none?(arr)
		if block_given?
			my_each(arr){|x| return false if yield(x)}
			true
		else
			my_each(arr){|x| return false if x}
			true
		end
	end
	def my_count(arr)
    		counter = 0
		if block_given?
        		my_each(arr){|x| counter += 1 if yield(x)}
    		else
        		my_each(arr){|x| counter += 1 if x} 
    		end
    		counter
	end
	def my_map(arr)
    		new_arr = []
    		if block_given?
		        my_each(arr){|x| new_arr << yield(x)}
		        new_arr
	    	end
	end
	def my_map_proc(arr, proc=nil)
    		new_arr = []
    		if block_given? && proc
    			my_each(arr){|x| new_arr << yield(x)}
		        my_each(arr){|x| new_arr << proc.call(x)}
		        new_arr
		end
	end
	def my_inject(arr, memo=0)
    		if block_given?
        		my_each(arr){|x| memo = yield(memo, x)}
        		memo
    		end
	end
	def multiply_els(arr)
    		my_inject(arr,1){|sum,x| sum = sum * x}
	end
end

include Enumberable

