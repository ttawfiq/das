
# prints a descending sequence of numbers

        get           # read first number
loop    put
        jp      pos   # jump to pos if positive
        add     one   # increment %r
        j       test  
pos     sub     one   # decrement %r
test    jz      done  # if it's zero, halt
        j       loop  

done    halt
one     const   1

