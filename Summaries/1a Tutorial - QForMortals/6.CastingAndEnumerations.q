////    CASTING    /////

/cast with $
/e.g. cast to int
`int$4.2
6h$4.2
"i"$4.2

/cast to symbol
`$"ab cd"

/creating typed empty lists
L:`int$()
L:0#ON    /use 0# with any value of the required type, typically null of the required type is used


////    PARSING STRINGS    ////

/use upper case type char
"I"$"4267"
"J" long
"F" float
"D"  date
"Z" datetime


////    ENUMERATIONS for symbol lists    ////
/note the enumaration mechanism can be applied to lists of symbol type only!
/inernally enumeration is stored as list of integers

q)symList:`c`b`a`c`c`b`a`b`a`a`a`c
q)domain:`c`b`a			 /domain:distinct symList
q)en:`domain$symList	 /to create enumeration cast to a given domain
q)en					 /type en is 20h+, different domains get different type
`domain$`c`b`a`c`c`b`a`b`a`a`a`c

q)value en
`c`b`a`c`c`b`a`b`a`a`a`c
q)en?`a     /locate first occurance
2
/locate all occurances
q)en=`a
001000101110b
q)where en=`a
2 6 8 9 10

/conditional enumeration
/create an enumeration using conditional append operator
/new symbols will be added to the domain
q)sym
'sym
q)`sym?`c`b`a`c`c`b`a`b`a`a`a`c	 /returns an enumeration and defines sym variable
`sym$`c`b`a`c`c`b`a`b`a`a`a`c
q)sym
`c`b`a
q)`sym ? `a`z		 /sym variable already defined, appends new symbols
`sym$`a`z
q)sym
`c`b`a`z

/special case of conditional enumeration when used with filepath
q)`:/db/sym?`a`b`a /will create a file with symbol list if it does not already exists
`sym$`a`b`a
/the above command overrides in momory sym variable with symbol list from the file
q)sym	`a`b
q)get `:/db/sym
`a`b
q)`:/db/sym?`z	 /updates sym list on the disk and overrides in memory sym variable
`sym$`z
q)sym
`a`b`z
q)get `:/db/sym
`a`b`z