{smcl}
{* *! version 1.1.1  11feb2011}{...}
{findalias asfrvarnew}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "[U] 11.4 varlists (varname)" "help varname"}{...}
{viewerjumpto "Description" "newvarlist##description"}{...}
{viewerjumpto "Examples" "newvarlist##examples"}{...}
{title:Title}

    {findalias frvarnew}


{marker description}{...}
{title:Description}

{pstd}
A {it:newvarlist} is a list of new variables:

{p 8 12 2}
    1.  A {it:newvarlist} can literally be a list of one or more 
        {it:{help newvar:newvars}}, listed one after another:

		{cmd:x}
		{cmd:x myvar inc92}

{p 8 12 2}
    2.  You may use a dash to specify a set of variables:

		{cmd:p1-p90}{col 43}(means {cmd:p1 p2} ... {cmd:p90})
		{cmd:inc90-inc99}{col 43}(means {cmd:inc90 inc91} ... {cmd:inc99})

{p 8 12 2}
    3.  You may specify a {it:{help data types:storage type}} of 
	{cmd:int}, 
	{cmd:long}, 
	{cmd:float}, 
	{cmd:double}, 
	or
	{cmd:str}{it:#}
	in front of any element of the list:

		{cmd:double x}
		{cmd:str2 name int myvar double inc92}

{p 8 12 2}
    4.  You may use parentheses to collect groups:

		{cmd:double(x myvar inc92) int(p1-p90)}

{p 12 12 2}
	The parentheses around {cmd:p1-p90} were not necessary, but 
	they clarify the meaning.

{p 8 12 2}
    5.  When you do not specify the type, the default type -- which is usually
	{cmd:float} -- is assumed:

		{cmd:double x myvar inc92}{col 43}({cmd:myvar} and {cmd:inc92} will be {cmd:float})

{p 12 12 2}
	The default usually is {cmd:float}, but you can change it to
	{cmd:double} if you wish; see {helpb set type}.

{pstd}
Because the default is {cmd:float} or {cmd:double}, you must specify
{cmd:str}{it:#} if you want to create a string variable.  Some commands
understand {cmd:str} (without the number) and determine the length themselves.
The {cmd:generate} command does not even require that {cmd:str} be specified;
it creates a {cmd:str}{it:#} variable, where {it:#} is the smallest string
that will hold the result.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Enter data on variable {cmd:x} from keyboard{p_end}
        {cmd:. input x}

                     x
          1. {cmd:1}
          2. {cmd:2}
          3. {cmd:end}

{pstd}Add data for variables {cmd:y} and {cmd:z} and make them type
{cmd:double}{p_end}
        {cmd:. input double (y z)}
        
              y           z
          1. {cmd:3 4}
          2. {cmd:5 6}

{pstd}Add data for variable {cmd:s} and make it type {cmd:str2}{p_end}
        {cmd:. input str2 s}

                     s
          1. {cmd:ab}
          2. {cmd:cd}

{pstd}Describe the data{p_end}
        {cmd:. describe}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl2}{p_end}
{phang2}{cmd:. generate str9 lastname = word(name, 2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl2, clear}{p_end}

{pstd}Equivalent to above {cmd:generate} command{p_end}
{phang2}{cmd:. generate str lastname = word(name, 2)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genxmpl2, clear}{p_end}

{pstd}Equivalent to above {cmd:generate} command{p_end}
{phang2}{cmd:. generate lastname = word(name, 2)}{p_end}
    {hline}
