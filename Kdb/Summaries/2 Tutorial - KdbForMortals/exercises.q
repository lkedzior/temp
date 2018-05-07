//reordering columns of the splayed table
    `:/db/t/.d set `p`ti
`:/db/t/.d

//manual sort by updating individual column files
    I:idesc t[`ti]		//e.g. 1 0
    {@[`:/db/t;x;:;t[I;x]]} each cols t
`:/db/t`:/db/t

//Adding a column to the splayed table
    n:count get `:/db/t/ti
    @[`:/db/t;`v;:;n#0]	//save /db/t/v file
`:/db/t
    @[`:/db/t;`.d;,;`v]	//update /db/t/.d file
`:/db/t
    \l /db/t
`t

//Deleting a column
//Column can be effectively deleted by updating .d file only
    `:/db/t/.d set `ti`p
`:/data/db/t/.d

//Good practice dictates removal of the orphaned file
    hdel `:/db/t/v 
`:/db/t/v

//removing a column p from a partitioned database example
d:exec date from select distinct date from t 
f:`:/db

{.[f;x,`t`.d;:;`ti`s]; hdel ` sv f,x,`t`p} each `$string d
`:/db/2007.01.01/t/p`:/db/2007.01.02/t/p
\l /db


//exercise to re-create a column data from c and c#
`:/temp/t/ set ([] c:(1 2;3 4 5;enlist 6))
q)csharp:1 2 3 4 5 6
q)c:2 3 1
q)(sums -1_0,c)
0 2 5
q)0 2 5 cut cs
1 2
3 4 5
,6
q)

//Add 42 to every eleventh or seventeenth item of a list

q)L:til 100
q)(til count L)mod/:11 17
0 1 2 3 4 5 6 7 8 9 10 0  1  2  3  4  5  6 7 8 9 10 0 1 2 3 4 5  6  7  8  9  ..
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 0 1 2 3 4  5 6 7 8 9 10 11 12 13 14 ..
q)B:(or/)0=(til count L)mod/:11 17
q)B
10000000000100000100001000000000011000000000100000010001000000000010100000000..
q)@[L;where B;+;42]
42 1 2 3 4 5 6 7 8 9 10 53 12 13 14 15 16 59 18 19 20 21 64 23 24 25 26 27 28..
q)

//notice interesting use of over / adverb. (or/) (L1;L2)	~	L1 or L2


//exercise: write a function which given a list of symbols returns a list of syms with only first char e.g. f[`aaa`bbb`ccc] -> `a`b`c
q)f:{`$(1#) each string x}
q)f1:{`$1#'string x}
q)f[`aaa`bbb`ccc]
`a`b`c
q)f1[`aaa`bbb`ccc]
`a`b`c

//exercise: write a function which takes a table and sym range e.g. `a`m
//it returns sub-table by with rows that have sym within given range
extr:{[t;r] select from t where (`$1#'string sym) within r}


//Example – read it in chunks and splayed the data into 2009.01.01 partition
q)ldchunk:{.Q.en[`:/db] flip `time`sym`price!("TSF";",") 0: x}
q).Q.fs[{.[`:/db/2009.01.01/t/;();,;ldchunk x]}] `:/data/trade.csv
2638724j
q)

