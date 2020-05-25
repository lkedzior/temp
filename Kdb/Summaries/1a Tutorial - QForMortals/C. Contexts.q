/define some variables in the context and save the context
q)t
q)f:{x+y}
q)value `.
t| +`x`y`z!(2 3 5;`ibm`amd`intel;"npn")
f| {x+y}

/saving the default context
/saving workspace, reading workspace
`:file set (value `.)
`. set (get `:file)

`:c:/context.bin set value `.

/overwriting context/namespace
`. set newContext /`a set 10 is like a:10

/working with contexts, which are dictionaries
.u.L ~ `.u[`L]    /first works because .u is a dictionary with sym keys

/removing variable from a context - standard syntax for column dictionaries
delete L from .u	 /will not update .u, need to refer by name `.u
delete L from `.u

/same works with dict
d:`a`b`c!10 20 30
delete a from d
delete a from `d

/show variable from a context
\v /from current one
\v .u

/show tables from a context
\a /from default
\a .u  /from given one



/
functions, global variables, context
If a function defines global variable, the context of this variable
depends on the context in which the function had been defined

example from tick

\d .u
init:{w::123}
\d .
.u.init[]
.u.w ->123 w is now in u context 
\

/only one level of the context is recognized .i.e \d .level1.level2 does not work
