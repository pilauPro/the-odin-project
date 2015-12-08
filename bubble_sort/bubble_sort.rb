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

#assumes block like: {|x,y| x<=>y}
def bubble_sort_by(arr, &block)
        (arr.size - 1).times{
            i = 0
            while i < arr.size - 1
                if block.call(arr[i],arr[i + 1]) == 1
                    temp = arr[i]
                    arr[i] = arr[i+1]
                    arr[i+1] = temp
                end
            i+=1
            end
        }
        arr
end