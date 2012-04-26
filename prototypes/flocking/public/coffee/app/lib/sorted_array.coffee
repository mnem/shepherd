define ->
    class SortedArray

        constructor: () ->
            @arr = new Array()

        push: (el) =>
            @arr.push el

        insert: (element, property, justIndex=false, lessThan=true) =>
            if @arr.length == 0
                if not justIndex
                    @arr.push element
                    return
                else
                    return -1
            imin = 0
            imax = @arr.length-1
            imid = 0
            while imax > imin
                imid = (imax+imin)>>1
                p = @arr[imid]
                if element[property] > p[property]
                    imin = imid+1
                else if element[property] < p[property]
                    imax = imid-1
                else
                    break

            # find out which index to return

            if justIndex
                imin += 1 if @arr[imin][property] < element[property]
                moreThan = not lessThan
                if moreThan
                    if imin == @arr.length
                        return -1
                    else
                        return imin
                if lessThan
                    return imin-1

            targetIndex = if @arr[imin][property] < element[property] then imin+1 else imin
            @arr[targetIndex...targetIndex] = [element]
