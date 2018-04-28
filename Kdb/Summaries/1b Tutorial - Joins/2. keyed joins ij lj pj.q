Some joins are keyed, in that columns in the first table are matched with the key columns of the second table
Second table must be keyed
t1 join kt2
kt1 join kt2
/FK relation will be used if exists
/if there is no FK column in leftTable then column names must match PK columns 

ij - inner join
lj - left join (also ljf variation)
pj - plus join, variation of left join, t2 values are added to t1 for common columns 

/////////////////////////////////    ij and lj    /////////////////////////////

/Inner join
/The result has one combined record for each row in t1 that matches a row in t2.
/If there is no match the record won't be included in the result table

/Left join
/All columns from t1 will be included in the results
/if there is a matching record in t2, it is joined to the t1 record. Common columns are replaced.
/if there is no matching record in t2, common columns are left unchanged, and new columns are null

q)t:([] sym:`IBM`FDP`IBM`MSFT; price:0.7 0.08 0.26 0.54)
q)t
sym  price
----------
IBM  0.7
FDP  0.08	 /will not be included, no FDP in kt table
IBM  0.26
MSFT 0.54

q)kt:([sym:`IBM`MSFT] ex:`N`CME; MC:1000 250)
q)kt
sym | ex  MC
----| --------
IBM | N   1000
MSFT| CME 250

/INNER JOIN - notice no FDP in the results
q)t ij kt
sym  price ex  MC
-------------------
IBM  0.7   N   1000
IBM  0.26  N   1000
MSFT 0.54  CME 250

/LEFT JOIN		alternative syntax t1 ,\: t2
q)t lj kt
sym  price ex  MC
-------------------
IBM  0.7   N   1000
FDP  0.08
IBM  0.26  N   1000
MSFT 0.54  CME 250

/lj vs ljf
Different behaviour for common columns
lj will replace values for common columns with null values if that is a value in the key table
ljf will not replace with nulls

q)t
a b
----
a 10
b 20
q)kt
a| b
-| ---
a| 100
b|
q)t lj kt
a b
-----
a 100
b
q)t ljf kt
a b
-----
a 100
b 20
q)


/LEFT JOINS
/Left joins subdivide into fkey and adhoc.
/The performance of an equijoin on a key is approximately 2.5 times faster than an ad hoc left join.

/fkey left join example (using ".")
kt2:([eid:1001 1002 1003] name:`Dent`Beeblebrox`Prefect; iq:98 42 126)
t1:([] eid:`kt2$1003 1001 1002 1001 1002 1001; score:126 36 92 39 98 42)

q)kt2
eid | name       iq
----| --------------
1001| Dent       98
1002| Beeblebrox 42
1003| Prefect    126

q)t1
eid  score
----------
1003 126
1001 36
1002 92
1001 39
1002 98
1001 42

q)select eid.name, score from t1
name       score
----------------
Prefect    126
Dent       36
Beeblebrox 92
Dent       39
Beeblebrox 98
Dent       42


/////////////////////////////////    plus join 't pj kt'    /////////////////////////////

pj is a variation on left join. For each matching row,
values from the second table are added to the first table,
instead of replacing values from the first table.

For each record in t1:
if there is a matching record in t2 it is added to the t1 record.
if there is no matching record in t2, common columns are left unchanged, and new columns are zero.

q)t:([]a:`a`b;b:10 20)
q)t
a b
----
a 10
b 20
q)kt:([a:`a`b] b:100 0Nj; c:1000 0Nj)
q)kt
a| b   c
-| --------
a| 100 1000
b|
q)t pj kt
a b   c
----------
a 110 1000
b 20  0
q)