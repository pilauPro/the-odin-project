def bubble_sort(arr)
    (arr.size - 1).times{
        i = 0
        while i < arr.size - 1
            if arr[i+1] < arr[i]
                temp = arr[i]
                arr[i] = arr[i+1]
                arr[i+1] = temp
            end
            i+= 1
        end
    }
    arr
end

input = [5,4,20,1,60,100,3,7,1000,2]

puts bubble_sort(input).inspect