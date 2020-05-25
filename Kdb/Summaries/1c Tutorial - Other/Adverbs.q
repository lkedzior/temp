//This content was originaly created from QForMortals but later more examples have been added

////    ADVERBS FOR MONADIC FUNCTIONS    ////

f each L	 /iterate over List and apply funcion f
each[f] L
q){x*x} til 10
0 1 4 9 16 25 36 49 64 81

/scan can be used for 3 different cases to execute recursive calls of f monadic function
1) f/[n;arg]
2) f/[monadCond;arg]
3) f/[arg]

/ 1) n recursive calls, return a list with consecutive results

f\[n;arg]	 /n recursive calls, returns the list with consecutive results
arg; f[arg]; f[f[arg]]; ...    /count n+1
q)f:{x*x}
q)f\[5;2]
2 4 16 256 65536 4294967296
q)

/in general if over(/) is used instead of scan(\) then only the final result is returned
q)f/[5;2]
4294967296
q)

/ 2) do while(cond) - recursive calls as long as condition is true (stops after first false)
fMonad\[monadicCondFunction;100]  //recursive calls as long as monadicCondFunction returns 1b

q)f:{x+1}
q)cond:{x<105}
q)f\[cond;100]
100 101 102 103 104 105

//alternative syntax
q)cond f\100
100 101 102 103 104 105

/ 3) recurive calls until argument = result (converge)
f\[arg]
q){floor x % 2}\[7]
7 3 1 0
/(7)(7%2)(3%2)(1%2)(0%2=0)

Practical example raze/ to flatten out a nested list to the level of simple list
raze is monadic, last call raze[flatList] = flatList

Practical example of this is finding the parent id

//table with id and previous id columns
q)t:([]id:1 2 3 4 5; prevId:0N 1 2 3 0N)
q)t
id prevId
---------
1
2  1
3  2
4  3
5

//Create a m dictionary
q)m:exec last prevId by id from t
q)m
1|
2| 1
3| 2
4| 3
5|
q)

//use the ditionary as a function with the scan
//it stops when we index with null and null is returned
q)update origId:(m\) each prevId from t
id prevId origId
------------------
1         ,0N
2  1      1 0N
3  2      2 1 0N
4  3      3 2 1 0N
5         ,0N
q)

//same but drop last null
q)update origId:(-1_) each (m\) each prevId from t
id prevId origId
------------------
1         `long$()
2  1      ,1
3  2      2 1
4  3      3 2 1
5         `long$()
q)

////    ADVERBS for dyadic functions    ////
easy way to remember syntax: it always starts with f/ or f\ or f'
f/ f\ f/: f\: f' f':
f\:[L;a]	 /each left		L f\: a
f/:[a;L]	 /each right	a f/: L

f'[L1;L2]	 /each both
f'[a;L]		 /a expanded to list
f'[L;a]		 /a expanded to list

f':[a;L]	 /each previous, applies f on consecutive items in a List

/over and scan are different, they use previous results for next call
/generally f/ ~ last f\
f/			 /over
f\			 /scan



/each right
q)-/: [100; 0 1 2 3]
100 99 98 97

/each both
f'[L1;L2] or L1 f' L2   
q)+'[1 2;3 4]
4 6
q)(1 2) +' (3 4)
4 6

/use each both when you have a function to call and need to execute it on
/list arguments, e.g. you need to execute it on itesms of L1,L2,... lists

/each vs each both
/exercise: write a function which given a list of symbols
/returns a list of syms with only first char e.g. f[`aaa`bbb`ccc] -> `a`b`c

q)x:1000000?`3
q)x
`mil`igf`kao`baf`kfh`jec`kfm`lkk`kfi`fgl`enf`plh`nni`glc`gkp`bgh`ifn`foh`kdj`..

q)\t `$1#'string x /is it faster because `$1# is applied on entire list ("mil";"igf";"kao";...) ?
234
q)\t `$(1#) each string x	 /this is slower because `$1# is applied separately on "mil" then on "igf" etc...
390

/each previous
f':[arg;L] /result is a list, f[L0;arg]; f[L1;L0]; f[L2;L1]; ...
f':[L] /no arg L0 ; f[L1;L0]; f[L2;L1]; ...

-':[0; 2 5 9 10]	 /deltas -':
(2-0;5-2;9-5;10-9)
2 3 4 1

q)-': [1 2 3]
1 (2-1) (3-2)
1  1    1


/over (f/) returns the result of the last call
/scan (f\) returns List of results from consecutive calls
f/[arg;L]		 /f[arg;L0; then f[pr;L1] ...
f\[arg;L]		 /f[arg;L0]; f[pr;L1]; f[pr;L2]; ... /pr - previous result

q)f:{show -3! x,y; x+y}
q)f/[100; 1 2 3]
"100 1"
"101 2"
"103 3"
106
q)
q)f\[100; 1 2 3]
"100 1"
"101 2"
"103 3"
101 103 106
q)

/without optional argument
q)f/[2 5 8]
"2 5"
"7 8"
15
q)f\[2 5 8]
"2 5"
"7 8"
2 7 15		 /note the first item L0 is included in the results
q)

/advanced use to remove multiple items from dictionary
        d:1 2 3!`a`b`c
        d _/1 3
2| b


/ example using ^ and scan to implement fills
f\ [0n 10 20 0n 0n 30 0n 40]
"0n^10  => 10"
"10^20  => 20"
"20^0n  => 20"
...

q)fills
^\
q)fills 0n 10 20 0n 0n 30 0n 40
0n 10 20 20 20 30 30 40
q)

//scan & over works the same way when left argument is a list, 
q)f:{show -3!(x;y); x+y}
q)(f\)[10 100; 1 2 3]
"(10 100;1)"
"(11 101;2)"
"(13 103;3)"
11 101
13 103
16 106

q)(f/)[10 100; 1 2 3]
"(10 100;1)"
"(11 101;2)"
"(13 103;3)"
16 106
q)

##############/scan & over for multivalent functions

##########scan with triadic function
q)f:{show -3!(x;y;z); x+y+z}
q)(f\)[1;10 20 30; 100 200 300]  // (f\)[arg;L1;L2]  //will run operation doing each both on L1&L2   f[prevResult;L1;L2]
"1 10 100"  //111
"111 20 200"  //331
"331 30 300"  //661
111 331 661
q)

q)f
{show -3!(x;y;z); x+y+z}
q)f\[1 5 6; 2 22; 3 33]
"(1 5 6;2;3)"
"(6 10 11;22;33)"
6  10 11
61 65 66
q)

(1 5 6) + 2 + 3		-> 6 10 11
(6 10 11) + 22 + 33 	-> 61 65 66

/example of over to apply dyadic operation on 2 items of a list
q)(-/)(10 10 10; 1 2 3)
9 8 7

/update test


//// combining adverbs ////
combining adverbs
in general f adverb1 advert2
  => (f adverb1) adverb2
  => g adverb2 where g=(f adverb1)

####example 1
(1 2 3),/:\:4 5 6
 -> (1,/:4 5 6),(2,/:4 5 6),(3,/:4 5 6) -> ((1 4i;1 5i;1 6i);(2 4i;2 5i;2 6i);(3 4i;3 5i;3 6i))

(1 2 3),/:\:4 5 6
  => (1 2 3) f\: 4 5 6   //f=,/:
  => 1 f 4 5 6
     2 f 4 5 6
     3 f 4 5 6
  => 1 ,/: 4 5 6
     2 ,/: 4 5 6
     3 ,/: 4 5 6
  => ((1 4i;1 5i;1 6i);(2 4i;2 5i;2 6i);(3 4i;3 5i;3 6i))


q)([]p:raze (1 2 3),/:\:4 5 6)
p
---
1 4
1 5
1 6
2 4
2 5
2 6
3 4
3 5
3 6

#########################
fn:{(+ ':)x,0};
pascal:{[numRows]
  fn\[numRows;1]
 };
([]p:pascal 7)

x:til 10
(+ ':)x,0
(+ ':)x

0 1 2 3 4 5 6  7  8  9  0j  //til[10],0
0 1 3 5 7 9 11 13 15 17 9j //(+ ':)til[10],0

####example 3
See examples on code.kx.com
http://code.kx.com/wiki/Cookbook/ProgrammingIdioms#How_do_I_apply_a_function_to_a_sequence_sliding_window.3F
slidingWindow:{[func;n;data]
  slices:flip reverse prev\[(n-1);data];
  /func each slices would work for most cases for functions like sum avg 
  func/'[slices]   / func/' is basically func/ each slices....f/ allows to have + (dyadic) as a function
 };

//here we run monadic upper on first item of the list upper["aa"]
q)@[("aa";"a";"bb");0;upper]
"AA"
"a"
"bb"

//Here we run (@[("aa");0;upper]; @[("a");0;upper]; @[("Bb");0;upper])
//@[;0;upper] each ("aa";"a";"bb")
//or equivalent using (')
q)@'[("aa";"a";"bb");0;upper]
"Aa"
"TYPE"
"Bb"
//typer error because we can't index an atom
q)"a"[0]
'type