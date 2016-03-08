/create dict, 99h
d:`a`b`c!1 2 3

key d
value d
d[`a] ~ d`a ~ d@`a

/use :: to make sure the type of keys or values stay generic
q)d:(`a`b`c)!(1;2;`aaa)
q)d[`c]:3
q)d[`c]:`a
'type

q)d:(`a`b`c)!(1;2;`aaa)
q)d _: `c		 /d: d _ `c
q)d
a| 1
b| 2
q)d[`c]:`aaa
'type

/using :: to keep the types generic
q)d:(::;`a;`b;`c)!(::;1;2;`aaa)
q)d _: `c
q)d[`c]:`bbb

/reverse lookup with ? and where
q)(`a`b`c!1 2 2)?2
`b
q)2=(`a`b`c!1 2 2)
a| 0
b| 1
c| 1
q)where 2=(`a`b`c!1 2 2)
`b`c

/take sub-dictionary
q)`a`b#(`a`b`c!1 2 3)
a| 1
b| 2

/upsert i.e. update or insert
d[`b`c]:20 30

/remove/drop one key
q)d
a| 1
b| 2
c| 3
q)d _ `a	 /does not change d underlying dict
b| 2
c| 3

d _/ `a`b	 /removing multiple items using over

/remove multiple keys - does not change underlying dict
`a`c _d
`a`c cut d

/remove with delete ... from - works only with column dictionaries
q)d:`a`b`c!1 2 3
q)delete a from d	 /d itself won't be changed
b| 2
c| 3
q)delete a from `d	 /using symbol name to update the dictionary
`d

/primitive operations
d1,d2
d1+d2
neg d1

/simple column dictionaries
`c1`c2`c3!(v1;v2;v3) 
/column dictionary - when v1,v2,v3 have common count 
/simple column dictionary - when v1,v2,v3 are simple lists 

/dot notation to access column value
d.c1	 /works when keys are symbols

/indexing at depth
d[`a][2]
d[`a;2]
.[d;(`a;2)]
.[`d;(`a;2)]

/projecting
d[`a;] /gives `a values, sames as d`a
d[;2]  /gives 3rd row
q)d
a| 0 1 2
b| 3 4 5
c| 6 7 8
q)d[;2]
a| 2
b| 5
c| 8

/flipping column dictionary - no data is re-arranged
flip d
