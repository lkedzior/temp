/lambda expression / anonymous function
{...}
/to execute it
{x+y}[4;5]

/if you need to create temp variable for next instructions, use {} blocks to create local variable instead of global 

/Functions
/The maximum valence currently permitted is 8
f:{[x;y;z] e1; e2; ...; en}		 /call it f[x;y;z]

/last expression is function value
/if last expr is followed by ; then it is void function, returns (::) null item
f:{[x;y] x+y;}
q)(::)~{123;}[]
1b

/ return with empty assigment :, returns from function with a value :value
q)f:{:123;x*x}
q)f[]
123



/ i+=1 from c/c++
i+:1

/change global variables from a function
f:{[x] b::7; x*b} /if used outside a function :: creates an alias

/function projection is the way to DEFINE new functions
/by using existing one and default argument
f:{x-y}
g:f[100;]
q)g
{x-y}[100;]

/verb projection
(2+)3 ~ (2+)[3]
/projection on left argument
f:-[;100]
/projection of right argument
f:-[10;]  or  f:(10-)	

. and @    /apply for functions
f:{x+y}

f[1;2] ~ f . 1 2 ~ .[f;1 2] ~ .[`f;1 2]	 /right argument must be a list e.g. f:{x*x} f . enlist 2
f[1 2] ~ f @ 1 2 ~ @[f;1 2] ~ @[`f;1 2]

/. and @ can be used to alter list/dict/table by applying a function f
/to modify original list/dict/table refer by name e.g. `L

/L@I - indexing at the top level
/L.I - indexing at depth
@[L;I;f]    /apply monadic f
@[L;0 1;neg]	 /will negate items at index 0 and 1 and return new List
@[`L;0 1;neg]	 /will modify L and return `L

@[L;I;f;y]  /apply dyadic f
@[L;1 2; +; 42 43]	 /add 42 to L[1], add 43 to L[2]


q)L:1 2 3 4
q)@[L;0 1; +; 100]
101 102 3 4
q)?[1100b; L+100; L]	 /same with conditional evaluation
101 102 3 4


/traditional assign fails at depth level
q)L[0][1]:42	 /would work at top level e.g. L[0]:(1 42 3)
'assign
/use indexing at depth instead
q).[L;0 1; : ;42]

/ the signal (') terminates function with en error, causes the calling routine to fail

/PROTECTED EVALUATION
@[f; arg; errorExpr] / if errorExpr is a function it will be execute
.[f; Larg; errorExpr]

/2 ways of signaling an error
q)f:{'errorMsg;4}	 /f[] switches to debug mode
q)g:{'`errorMsg;4}	 /g[] does not switch to debug mode

q)f[]
{'errorMsg;4}
'errorMsg
q))\

q)g[]
'errorMsg
/using protected evaluation - errorExpr gets error message as string parameter
q)@[f; ::; {x}]
"errorMsg"
q)@[g; ::; {x}]
"errorMsg"

/example with multivalent function
q).[*;(6;`7);`$" Invalid args for *"]
`Invalid args for *
q).[*;(6;`7);{`$" Invalid args for *"}]
`Invalid args for *
q).[*;(6;`7);{`$" Invalid args for *, errorMsg=",x}]
`Invalid args for *, errorMsg=type



