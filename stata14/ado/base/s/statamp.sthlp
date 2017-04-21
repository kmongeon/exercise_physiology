{smcl}
{* *! version 1.4.4  29jun2015}{...}
{vieweralsosee "[R] about" "help about"}{...}
{vieweralsosee "[D] data types" "help data_types"}{...}
{vieweralsosee "[R] matsize" "help matsize"}{...}
{vieweralsosee "[D] memory" "help memory"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "[U] 5 Flavors of Stata" "help flavors"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "limits" "help limits"}{...}
{vieweralsosee "Small Stata" "help small_stata"}{...}
{vieweralsosee "Stata/IC" "help stataic"}{...}
{vieweralsosee "Stata/SE" "help statase"}{...}
{viewerjumpto "Using Stata/MP" "statamp##use"}{...}
{viewerjumpto "Contents" "statamp##contents"}{...}
{marker use}{...}
{title:Using Stata/MP}

{pstd}
There are four flavors of Stata:

{col 13}Flavor{col 29}Description
{col 13}{hline 47}
{col 13}{bf:Small Stata}{col 29}for undergraduate students
{col 13}{bf:Stata/IC}{col 29}standard version 
{col 13}{bf:Stata/SE}{col 29}Stata/IC + large datasets
{col 10}-> {bf:Stata/MP}{col 29}Stata/SE + parallel processing
{col 13}{hline 47}
{col 13}See {bf:{help flavors:[U] 5 Flavors of Stata}} for descriptions

{pstd}
To determine which flavor of Stata you are running, type

	    {cmd:. about}

{pstd}
If you are using a different flavor of Stata, click on the appropriate
link:  

{col 13}{hline 47}
{col 13}{bf:{help small_stata:Small Stata}}{col 29}Using Small Stata
{col 13}{bf:{help stataic:Stata/IC}}{col 29}Using Stata/IC
{col 13}{bf:{help statase:Stata/SE}}{col 29}Using Stata/SE
{col 13}{hline 47}

{pstd}
For information on upgrading to Stata/MP, point your browser to
{browse "http://www.stata.com"}.


{marker contents}{...}
{title:Contents}

	1.  {help statamp##starting:Starting Stata/MP}

	2.  {help statamp##setting:Setting Stata/MP's limits}
	    2.1  {help statamp##processors:Advice on setting processors}
	    2.2  {help statamp##maxvar:Advice on setting maxvar}
	    2.3  {help statamp##matsize:Advice on setting matsize}

	3.  {help statamp##dta:Sharing .dta datasets with non-MP users}

	4.  {help statamp##query:Querying memory usage}

	5.  {help statamp##programming:Advice to programmers}
	    5.1  {help statamp##flavor:Determining flavor}
	    5.2  {help statamp##macshift:Avoid macro shift in program loops}


{marker starting}{...}
{title:1.  Starting Stata/MP}

{pstd}
You start Stata/MP in much the same way as you start Stata/IC or Stata/SE:

{p 8 12 4}
    Windows:{break}
	Select {bf:Start > All Programs > Stata {ccl stata_version} > StataMP {ccl stata_version}}

{p 8 12 4}
    Mac:{break}
        Double-click the file {hi:Stata.do} from the {hi:data} folder, or
        double-click the {hi:StataMP} icon from the {hi:Stata} folder.

{p 8 12 4}
    Unix:{break}
	At the Unix command prompt, type {cmd:xstata-mp} to invoke the
	GUI version of Stata/MP, or type {cmd:stata-mp} to invoke the
	console version.


{marker setting}{...}
{title:2.  Setting Stata/MP's limits}

{pstd}
The three limits for Stata/MP are as follows:

{p 8 16 4}
    1.  {cmd:processors}{break}
	    The maximum number of processors or cores to be used.
	    This limit is initially set to (1) the number of cores on
	    your computer or (2) the number of cores allowed by your
	    license, depending on which is less.  You reset the limit if 
	    you want to use fewer processors than that, say because you 
	    want to leave processors free for some other, non-Stata task.

{p 8 16 4}
    2.  {cmd:maxvar}{break}
	    The maximum number of variables allowed in a dataset.
	    This limit is initially set to 5,000; you can increase it
	    up to 32,767.

{p 8 16 4}
    3.  {cmd:matsize}{break}
	    The maximum size of matrices, or said differently, the
	    maximum number of independent variables allowed in the models that
	    you fit.  This limit is initially set to 400, and you can
	    increase it up to 11,000.

{pstd}
You reset the limits by using the

	    {cmd:set processors} {it:#}
	    {cmd:set maxvar}     {it:#}          [{cmd:,} {cmdab:perm:anently}]
	    {cmd:set matsize}    {it:#}          [{cmd:,} {cmdab:perm:anently}]

{pstd}
commands.  For instance, you might type

	    {cmd:. set processors 4}
	    {cmd:. set maxvar     6000}
	    {cmd:. set matsize    900}

{pstd}
The order in which you set the limits does not matter.  If you specify the
{cmd:permanently} option for {cmd:maxvar} or {cmd:matsize}, in addition to
making the change for the present session, Stata/MP will remember the new limit
and use it in the future when you invoke Stata/MP:

	    {cmd:. set maxvar  6000, permanently}
	    {cmd:. set matsize 900, permanently}

{pstd}
You can reset the present or permanent limits whenever and as often as you
wish.  Option {cmd:permanently} may not be specified with {cmd:set}
{cmd:processors}.


{marker processors}{...}
{title:2.1  Advice on setting processors}

	    {cmd:set processors} {it:#}
	
{pstd}
You may set the number of processors to be used to any number up to 
the lessor of 
(1) the number of cores on your computer and 
(2) the number of cores licensed.
You may even set {cmd:processors} to 1, and then
Stata/MP is effectively identical to Stata/SE.  

{pstd}
In general, you will get the best performance by using all processors 
available, leaving {cmd:processors} set to the default.
If you are running a large Stata job in the background, however, you may want
to reduce the maximum number that Stata/MP will use to have better 
performance in your foreground tasks.
If you are running two large Stata jobs in the background, you may get 
slightly better performance if you restrict each to using half the 
number of processors.


{marker maxvar}{...}
{title:2.2  Advice on setting maxvar}

	    {cmd:set maxvar}  {it:#} [{cmd:,} {cmdab:perm:anently}]{right:2,048 <= {it:#} <= 32,767    }

{pstd}
Why is there a limit on {cmd:maxvar}?  Why not just set {cmd:maxvar} to
32,767 and be done with it?  Because simply allowing room for variables, even
if they do not exist, consumes memory, and if you will be
using only datasets with a lot fewer variables, you will be wasting memory.

{pstd}
The formula for the amount of memory consumed by {cmd:set maxvar} is
approximately

{center:Number of megabytes = .3147*({cmd:maxvar}/1000) + .002  }

{pstd}
For instance, if you set {cmd:maxvar} to 20,000, the memory used would be
approximately

{center:Number of megabytes = .3147*20 + .002 = 6.296 MB}

{pstd}
and if you left it at the default, the memory use would be roughly

{center:Number of megabytes = .3147*5  + .002 = 1.575 MB}

{pstd}
Thus how big you set {cmd:maxvar} does not dramatically affect memory usage.
Still, at {cmd:maxvar}=32,000, memory use is 10.072 MB.

{p 8 8 4}
    {bf:Recommendation}:  Think about datasets with the most variables that
    you typically use.  Set {cmd:maxvar} to a few hundred or even 1,000
    above that.  (The memory cost of an extra 1,000 variables is
    only .317 MB.)

{p 8 8 4}
    {bf:Remember}, you can always reset {cmd:maxvar} temporarily by typing
    {cmd:set maxvar} {it:#}.


{marker matsize}{...}
{title:2.3  Advice on setting matsize}

	    {cmd:set matsize} {it:#} [{cmd:,} {cmdab:perm:anently}]{right:10 <= {it:#} <= 11,000    }

{pstd}
The name {cmd:matsize} is unfortunate because it suggests something that is
only partially true.  It suggests that the maximum size of matrices is
{cmd:matsize} {it:x} {cmd:matsize}.  {cmd:matsize}, however, is 
irrelevant for the size of matrices in Mata, Stata's modern matrix-programming
language.  Regardless of the value of {cmd:matsize}, Mata
matrices be larger or smaller than that.

{pstd}
{cmd:matsize} specifies the maximum size of matrices in Stata's old matrix
language -- and that is not of great importance -- and it specifies the
maximum number of variables that may appear in Stata's estimation commands --
and that is important.  A better name for {cmd:matsize} would be
{cmd:modelsize}.

{pstd}
With that introduction, let us begin.

{pstd}
Although {cmd:matsize} can theoretically be set up to 11,000, on all but the
largest 64-bit computers you will be unable to do that, and even if you
succeeded, Stata/MP would probably run out of memory.  The value of
{cmd:matsize} has a dramatic effect on memory usage, the formula being

{center:Number of megabytes = (8*{cmd:matsize}^2 + 88*{cmd:matsize})/(1024^2)}

{pstd}
For instance, 

{center:{c TLC}{hline 11}{c TT}{hline 14}{c TRC}}
{center:{c |}  {cmd:matsize}  {c |}  Memory use  {c |}}
{center:{c LT}{hline 11}{c +}{hline 14}{c RT}}
{center:{c |}      400  {c |}      1.254M  {c |}}
{center:{c |}      800  {c |}      4.950M  {c |}}
{center:{c |}    1,600  {c |}     19.666M  {c |}}
{center:{c |}    3,200  {c |}     78.394M  {c |}}
{center:{c |}    6,400  {c |}    313.037M  {c |}}
{center:{c |}   11,000  {c |}    924.080M  {c |}}
{center:{c BLC}{hline 11}{c BT}{hline 14}{c BRC}}

{pstd}
The formula, in fact, understates the amount of memory certain
Stata commands use and understates what you will use
yourself if you use Stata's old matrix language matrices directly.  The
formula gives the amount of memory required for one matrix and 11 vectors.  If
two matrices are required, the numbers above are nearly doubled.  When you
{cmd:set matsize}, Stata will refuse if you specify too large a value, but
remember that even if Stata does not complain, you still may run into
problems later.  Stata might be running some statistical command and then
complain, "op. sys. refuses to provide memory; r(909)".

{pstd}
For {cmd:matsize}=11,000, nearly 1 GB of memory is required, and
doubling that would require nearly 2 GB of memory.  On most 32-bit
computers, 2 GB is the most memory that the operating
system will allocate to one task, so nearly nothing would be left for
the rest of Stata.

{pstd}
Why, then, is {cmd:matsize} allowed to be set so large?  Because on 64-bit
computers, such large amounts cause no difficulty.

{pstd}
For reasonable values of {cmd:matsize} (say, up to 3,200), memory consumption
is not too great.   Choose a reasonable value given the kinds of models
you fit, and remember that you can always reset the value.


{marker dta}{...}
{title:3.  Sharing .dta datasets with non-MP users}

{pstd}
You may share datasets with Stata/SE users.

{pstd}
You may share datasets with Stata/IC or Small Stata users
as long as your dataset does not have more variables than are allowed
in those flavors of Stata; see {help limits}.


{marker query}{...}
{title:4.  Querying memory usage}

{pstd}
The command

	    {cmd:. memory}

{pstd}
will display the current memory report and the command 

	    {cmd:. query memory}

{pstd}
will display the current memory settings.
See {help memory:help memory}.



{marker programming}{...}
{title:5.  Advice to programmers}


{marker flavor}{...}
{title:5.1  Determining flavor}

{pstd}
Programmers can determine which flavor of Stata is running by 
examining the {help creturn} values

		                 creturn values
                        {c |} {cmd:c(flavor)   c(SE)     c(MP)}
	    {hline 12}{c +}{hline 30}
	    Small Stata {c |}  "{cmd:Small}"      0         0
	    Stata/IC    {c |}  "{cmd:IC}"         0         0
	    Stata/SE    {c |}  "{cmd:IC}"         1         0
	    Stata/MP    {c |}  "{cmd:IC}"         1         1
	    {hline 12}{c BT}{hline 30}


{marker macshift}{...}
{title:5.2  Avoid macro shift in program loops}

{pstd}
{helpb macro:macro shift} has negative performance implications when used with
variable lists containing 20,000 or more variables.  We recommend avoiding the
use of {cmd:macro shift} in loops and instead 
using either {helpb foreach} or "double
indirection".  Double indirection means referring to {cmd:``i''} when
{cmd:`i'} contains a number 1, 2, ....
{p_end}