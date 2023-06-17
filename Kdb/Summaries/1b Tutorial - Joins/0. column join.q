/ ,' column join to create new table, requires same count
/t1,'t2 joins records to records
t1 ,' t2

//another way to do it is with ^
t1^t2


q)t:([]a:1 2;b:`a`b)
q)r:([]c:10 20;d:1.2 3.4)

q)t
a b
---
1 a
2 b

q)r
c  d
------
10 1.2
20 3.4

q)t,'r
a b c  d
----------
1 a 10 1.2
2 b 20 3.4
q)t^r
a b c  d
----------
1 a 10 1.2
2 b 20 3.4
q)