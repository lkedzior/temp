
////	LISTS	////

/create one-item list
enlist 42
(),42    / , is a join for lists

/assigning multiple values at the same time
L[1 2]:10
L[1 2]:10 20

/returns entire list, :: denotes the null item
L ~ L[] ~ L[::] ~ L ::

/using null item :: to define general list
L:(1;2;3;`a;::)
L[3]:4	   /would change L type 0h->6h without :: at the end
L[3]:`a    /and here would fail without :: at the end

/indexing at depth
L[0][1] ~ L[0;1] ~ .[L; 0 1]

/indexing multiple items
L 0 1 ~ L[0 1] ~ @[L; 0 1]

/example
q)L:(1 2; 3; `a`b`c)

q)L[0;1]
2

q)L[0 1]
1 2
3

/Indexing with general list - the result always has the same shape as the index.
        L1:100 200 300 400
        L1[(0 1; 2 3)]
100 200
300 400

        I:(1;(0;(3 2)))
        L1[I]
200
(100;400 300)

/item lookup, returns the index of the FIRST appearance of x
/returns the count if an item does not exists
L?x
q)L:0 1 1 2
q)L?1
1

/eliding /I'laIdIng/ indices /'IndIsi:z/
L[1;]
L[;1]

q)m:(1 2 3 4; 100 200 300 400; 1000 2000 3000 4000)
q)m
1    2    3    4
100  200  300  400
1000 2000 3000 4000

        m[1;]
100 200 300 400

        m[;1]
2 200 2000

/transpose the rectangular list
flip L

/Drop first elements, drop last elements
q)5_0 1 2 3 4 5 6 7 8
5 6 7 8
q)-5_0 1 2 3 4 5 6 7 8
0 1 2 3

/drop first, drop last
q)1_0 1 2 3
1 2 3
q)-1_0 1 2 3
0 1 2

/drop/remove the 5th item
q)0 1 2 3 4 5 6 7 8_5      
0 1 2 3 4 6 7 8


/cut operator
/It partitions a list into sublists at the specified indices.
/left argument is a list of indices of the first elements in the sublists
q)2 5 cut 0 1 2 3 4 5 6	 /or 2 5 _ 0 1 2 3 4 5 6 
2 3 4
5 6

q)0 2 5 cut 0 1 2 3 4 5 6
0 1
2 3 4
5 6

/Exercise - using cut find indexes of the longest sequence of ones
/for x:0 1 1 1 1 1 1 0 0 0 1 1 1 1 1 0 0 1
/result should be 1 2 3 4 5 6
q)x:0 1 1 1 1 1 1 0 0 0 1 1 1 1 1 0 0 1
q)w:where x
q)w
1 2 3 4 5 6 10 11 12 13 14 17

q)ci:where 1<>10 -': w /where 1<>(-':)w would return 6 11, 10 value is arbitrary
q)ci
0 6 11

q)ix:ci cut w
q)ix
1 2 3 4 5 6
10 11 12 13 14
,17


q)ix where c=max c:count each ix
1 2 3 4 5 6

/everything in 1 line
ix where c=max c:count each ix:(where 1<>-666-':w)_w:where x

/Eliding indices for a general list
 L:((1 2 3;4 5 6 7);(`a`b`c`d;`z`y`x`;`0`1`2);("now";"is";"the"))
 L
(1 2 3;4 5 6 7)
(`a`b`c`d;`z`y`x`;`0`1`2)
("now";"is";"the")

/from all rows and all columns retrieve 1st item
L[;;1]	 /retrieve 1st position at the second level(second level as all rows all columns?)
2 5
`b`y`1
"osh"

