{smcl}
{* *! version 1.0.6  31aug2016}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS] intro" "mansection PSS intro"}{...}
{vieweralsosee "[PSS] power" "mansection PSS power"}{...}
{vieweralsosee "[PSS] Glossary" "help pss_glossary"}{...}
{vieweralsosee "[ST] stpower" "help stpower"}{...}
{viewerjumpto "Syntax" "power_userwritten##syntax"}{...}
{viewerjumpto "Description" "power_userwritten##description"}{...}
{viewerjumpto "Options" "power_userwritten##options"}{...}
{viewerjumpto "Remarks and examples" "power_userwritten##remarks"}{...}
{title:Title}

{p2colset 5 26 28 2}{...}
{p2col :{bf:power userwritten} {hline 2}}Adding your own methods to the power command{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Compute sample size

{p 8 16 2}
{cmd:power} {help power_userwritten##usermethod:{it:usermethod}}
...
[{cmd:,} {opth p:ower(numlist)}
{help power##power_options:{it:poweropts}}
{help power_userwritten##useropts:{it:useropts}} {cmd:programok twosample}]


{pstd}
Compute power

{p 8 16 2}
{cmd:power} {help power_userwritten##usermethod:{it:usermethod}}
...{cmd:,} {opth n(numlist)}
[{help power##power_options:{it:poweropts}}
{help power_userwritten##useropts:{it:useropts}} {cmd:programok twosample}]


{pstd}
Compute effect size

{p 8 16 2}
{cmd:power} {help power_userwritten##usermethod:{it:usermethod}}
...{cmd:,} {opth n(numlist)} {opth p:ower(numlist)}
[{help power##power_options:{it:poweropts}}
{help power_userwritten##useropts:{it:useropts}} {cmd:programok twosample}]


{marker usermethod}{...}
{phang}
{it:usermethod} is the name of the method you would like to add to the
{cmd:power} command.  When naming your {cmd:power} methods, you should follow
the same convention as for naming the programs you add to Stata -- do not pick
"nice" names that may later be used by Stata's official methods.

{marker useropts}{...}
{phang}
{it:useropts} are the options supported by your method
{it:usermethod}.


{marker description}{...}
{title:Description}

{pstd}
The {helpb power} command allows you to add your own methods to
{cmd:power} and produce tables and graphs of results automatically.


{marker options}{...}
{title:Options}

{phang}
{cmd:programok} specifies that {cmd:power} accept programs that are not
defined by an ado-file.

{phang}
{cmd:twosample} indicates a two-sample method.  You must specify this option
for {cmd:power} to allow the specification of its two-sample options
{cmd:n1()}, {cmd:n2()}, {cmd:nratio()}, and {cmd:compute()}.


{marker remarks}{...}
{title:Remarks and examples}

{pstd}
Adding your own methods to {cmd:power} is easy.  Say that you want to add a
method called {cmd:mymethod} to {cmd:power}.  Simply,

{phang}
1.  write an ado-file that contains an {help program:r-class program} called
   {cmd:power_cmd_mymethod}, which computes power, sample size, or effect size
   and follows {cmd:power}'s convention for naming common options and storing
   results; and

{phang}
2.  place the program where Stata can find it.

{pstd}
You are done.  You can now use {cmd:mymethod} within {cmd:power} like any
other official {cmd:power} method.

{pstd}
Remarks are presented under the following headings:

{p 8 8 2}{help power_userwritten##introex:A quick example}{p_end}
{p 8 8 2}{help power_userwritten##steps:Steps for adding a new method to the power command}{p_end}
{p 8 8 2}{help power_userwritten##convention:Convention for naming options and storing results}{p_end}
{p 8 8 2}{help power_userwritten##usernumlist:Allowing multiple values in method-specific options}{p_end}
{p 8 8 2}{help power_userwritten##usertable:Customizing default tables}{p_end}
{p 12 12 2}{help power_userwritten##usertablecols:Setting supported columns}{p_end}
{p 12 12 2}{help power_userwritten##usertabletabcols:Modifying the default table columns}{p_end}
{p 12 12 2}{help power_userwritten##usertablelabs:Modifying the look of the default table}{p_end}
{p 12 12 2}{help power_userwritten##usertableex:Example continued}{p_end}
{p 8 8 2}{help power_userwritten##usergraph:Customizing default graphs}{p_end}
{p 8 8 2}{help power_userwritten##userother:Other settings}{p_end}
{p 8 8 2}{help power_userwritten##userparse:Handling parsing more efficiently}{p_end}
{p 8 8 2}{help power_userwritten##moreexamples:More examples: Adding two-sample methods}{p_end}
{p 8 8 2}{help power_userwritten##sresults:Initializer's s() return settings}{p_end}

{pstd}
Also see the 
{browse "http://www.stata.com/meeting/uk13/abstracts/uk13_marchenko.pdf":Power of the power command} presentation for more examples.


{marker introex}{...}
{title:A quick example}

{pstd}
Before we discuss the technical details in the following sections, let's try
an example.  Let's write a program to compute power for a one-sample {it:z}
test given sample size, standardized difference, and significance level.  For
simplicity, we assume a two-sided test.  We will call our new method
{cmd:myztest}.

{pstd}
We create an ado-file called {cmd:power_cmd_myztest.ado} that contains the
following Stata program:

{p 12 18 2}// evaluator{p_end}
{p 12 18 2}{cmd:program power_cmd_myztest, rclass}{p_end}
{p 20 26 2}{cmd:version 13.1}{p_end}
{p 40 46 2}/* parse options */{p_end} 
                    {cmd:syntax , n(integer)}       /// sample size
                             {cmd:STDDiff(real)}    /// standardized difference
                             {cmd:Alpha(string)}    /// significance level

{p 40 46 2}/* compute power */{p_end}
{p 20 26 2}{cmd:tempname power}{p_end}
{p 20 26 2}{cmd:scalar `power' = normal(`stddiff'*sqrt(`n') - invnormal(1-`alpha'/2))}{p_end}

{p 40 46 2}/* return results */{p_end}
{p 20 26 2}{cmd:return scalar power   = `power'}{p_end}
{p 20 26 2}{cmd:return scalar N       = `n'}{p_end}
{p 20 26 2}{cmd:return scalar alpha   = `alpha'}{p_end}
{p 20 26 2}{cmd:return scalar stddiff = `stddiff'}{p_end}
{p 12 18 2}{cmd:end}{p_end}

{pstd}
Our ado program consists of three sections: the {helpb syntax} command for
parsing options, the power computation, and stored or return results:

{p 8 8 2}
The {cmd:power_cmd_myztest} program has two of {cmd:power}'s common options,
{cmd:n()} for sample size and {cmd:alpha()} for significance level, and it has
its own option {cmd:stddiff()} to specify a standardized difference.

{p 8 8 2}
After the options are parsed, the power is computed and stored in a 
{help tempname:temporary scalar} {cmd:`power'}.

{p 8 8 2}
Finally, the resulting power and other results are stored in return scalars.
Following {cmd:power}'s {help power_userwritten##convention:convention} for
naming commonly returned results, the computed power is stored in
{cmd:r(power)}, the sample size in {cmd:r(N)}, and the significance level in
{cmd:r(alpha)}.  The program additionally stores the standardized difference
in {cmd:r(stddiff)}.

{pstd}
We can now use {cmd:myztest} within {cmd:power} as we would any other 
existing method of {cmd:power}:

{phang2}{cmd:. power myztest, alpha(0.05) n(10) stddiff(0.25)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1211}{res}{ralign 8:10}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c BRC}

{pstd}
We can compute results for multiple sample sizes by specifying multiple values
in option {cmd:n()}.  Note that our {cmd:power_cmd_myztest} program accepts
only one value at a time in option {cmd:n()}.  When a {help numlist} is
specified in the {cmd:power} command's {cmd:n()} option, {cmd:power}
automatically handles that {it:numlist} for us.

{phang2}{cmd:. power myztest, alpha(0.05) n(10 20) stddiff(0.25)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1211}{res}{ralign 8:10}{txt} {c |}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1999}{res}{ralign 8:20}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c BRC}

{pstd}
We can even compute results for multiple sample sizes and significance levels
without any additional effort on our part:

{phang2}{cmd:. power myztest, alpha(0.01 0.05) n(10 20) stddiff(0.25)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.01}{res}{ralign 8:.03711}{res}{ralign 8:10}{txt} {c |}
          {txt}{c |}{res}{ralign 8:.01}{res}{ralign 8:.07245}{res}{ralign 8:20}{txt} {c |}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1211}{res}{ralign 8:10}{txt} {c |}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1999}{res}{ralign 8:20}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c BRC}

{pstd}
We can even produce a graph by merely specifying the {cmd:graph} option:

{phang2}{cmd:. power myztest, alpha(0.01 0.05) n(10(10)100) stddiff(0.25) graph}
{p_end}
          {it:({stata "power myztest, alpha(0.01 0.05) n(10(10)100) stddiff(0.25) graph":click to run})}

{pstd}
The above is just a simple example.  Your program can be as complicated as you
would like.  You can even use simulations to compute your results.  You can
also customize your tables and graphs with only a little extra effort.

{pstd}
See the 
{browse "http://www.stata.com/meeting/uk13/abstracts/uk13_marchenko.pdf":Power of the power command} presentation for more examples.


{marker steps}{...}
{title:Steps for adding a new method to the power command}

{pstd}
Suppose you want to add your own method, {it:usermethod}, to the {cmd:power}
command.  Here is an outline of the steps to follow:

{marker evaluator}{...}
{phang}
1.  Create the {it:evaluator}, an {help program:r-class program} called
{cmd:power_cmd_}{it:usermethod} and defined by the ado-file 
{cmd:power_cmd_}{it:usermethod}{cmd:.ado} that performs power and sample-size
computations and follows {cmd:power}'s 
{help power_userwritten##convention:convention} for naming options and
storing results.

{marker initializer}{...}
{phang}
2.  Optionally, create an {it:initializer}, an 
{help program:s-class program} called
{cmd:power_cmd_}{it:usermethod}{cmd:_init} and defined by the ado-file
{cmd:power_cmd_}{it:usermethod}{cmd:_init.ado} that specifies information
about table columns, options that may allow a {help numlist}, and so on.

{marker parser}{...}
{phang}
3.  Optionally, create an {it:parser}, a program called
{cmd:power_cmd_}{it:usermethod}{cmd:_parse} and defined by the ado-file
{cmd:power_cmd_}{it:usermethod}{cmd:_parse.ado} that checks the syntax of
user-specific options, {it:useropts}.

{phang}
4.  Place all of your programs where Stata can find them.

{pstd}
You can now use your {it:usermethod} with {cmd:power}:

{phang2}{cmd:. power} {it:usermethod} ...{p_end}

{pstd}
You may also use programs within {cmd:power} that are not defined by an
ado-file (that is, they were defined in a do-file or by hand).  In this case,
you must specify the {cmd:programok} option with {cmd:power}:

{phang2}{cmd:. power} {it:usermethod} ... {cmd:, programok} ...{p_end}


{marker convention}{...}
{title:Convention for naming options and storing results}

{pstd}
For the {cmd:power} command to automatically recognize its 
{help power##power_options:common options}, you must ensure that you
follow {cmd:power}'s naming convention for these options in your program.  For
example, {cmd:power} specifies the significance level in option {cmd:alpha()}
with minimum abbreviation of {cmd:a()}.  You need to make sure that you use the
same option with the same abbreviation in your evaluator to specify the
significance level.  The same applies to all of {cmd:power}'s 
{help power##power_options:common options} described in {manhelp power PSS}.

{pstd}
You can specify additional method-specific results, but {cmd:power} will not
know about them unless you make it aware of them; see 
{it:{help power_userwritten##usernumlist:Allowing multiple values in method-specific options}} for details.

{pstd}
To produce tables and graphs of results, you must ensure that your evaluator
follows {cmd:power}'s convention for storing results.  {cmd:power}'s
commonly stored results are described in 
{help power##results:{it:Stored results}} of {manhelp power PSS}.  For
example, the value for power should be stored in the scalar {cmd:r(power)},
the value for a total sample size in the scalar {cmd:r(N)}, the value for a
significance level in {cmd:r(alpha)}, and so on.

{pstd}
You can also store additional method-specific results, but {cmd:power} will
not know about them unless you make it aware of them; see 
{it:{help power_userwritten##usertable:Customizing default tables}} for details.


{marker usernumlist}{...}
{title:Allowing multiple values in method-specific options}

{pstd}
By default, the {cmd:power} command accepts multiple values only within its
{help power##power_options:common options}.  If you want to allow multiple
values in the method-specific options {it:useropts}, you need to let
{cmd:power} know about them.  This is done via the 
{help power_userwritten##initializer:initializer}.

{pstd}
To allow the specification of multiple values, or a {help numlist}, in
method-specific options, you need to list the names of the options with proper
abbreviations in an s-class macro {cmd:s(pss_numopts)} within the
{cmd:power_cmd_}{it:usermethod}{cmd:_init} program.

{pstd}
Recall our earlier {help power_userwritten##introex:example} in which we
added the {cmd:myztest} method, calculating the power of a two-sided one-sample
{it:z} test, to {cmd:power}.  We computed powers for multiple values of
significance level and sample size.  What if we would also like to specify
multiple values of standardized differences in the {cmd:stddiff()} option of
{cmd:myztest}?  If we do this now, we will receive an error message,

{phang2}{cmd:. power myztest, alpha(0.05) n(10) stddiff(0.25 0.5)}{p_end}
{phang2}{red:option stddiff() invalid}{p_end}
{phang2}{search r(198):r(198);}{p_end}

{pstd}
because the {cmd:stddiff()} option is not allowed to include a {it:numlist} by
the evaluator and is not one of {cmd:power}'s common options.  To make
{cmd:power} recognize this option as one allowing a {it:numlist}, we need
to specify this in the initializer.  Following the guidelines, we create an
ado-file called {cmd:power_cmd_myztest_init.ado} and specify the name of the
{cmd:stddiff()} option (with the corresponding abbreviation) in the s-class
macro {cmd:s(pss_numopts)} within the {cmd:power_cmd_myztest_init} program.

{p 12 18 2}// initializer{p_end}
{p 12 18 2}{cmd:program power_cmd_myztest_init, sclass}{p_end}
{p 20 26 2}{cmd:version 13.1}{p_end}
{p 20 26 2}{cmd:sreturn clear}{p_end}
{p 20 26 2}{cmd:sreturn local pss_numopts "STDDiff"}{p_end}
{p 12 18 2}{cmd:end}{p_end}

{pstd}
We now can specify multiple standardized differences:

{phang2}{cmd:. power myztest, alpha(0.05) n(10) stddiff(0.25 0.5)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1211}{res}{ralign 8:10}{txt} {c |}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.3524}{res}{ralign 8:10}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c BRC}


{marker usertable}{...}
{title:Customizing default tables}

{pstd}
The {cmd:power} command with user-written methods always displays results in a
table.  By default, it displays columns {cmd:alpha}, {cmd:power}, or
{cmd:beta} (whichever is specified) and {cmd:N}, which contain the significance
level, the power, and the sample size, respectively.  See 
{it:{help power_userwritten##usertablecols:Setting supported columns}} and 
{it:{help power_userwritten##usertabletabcols:Modifying the default table columns}}
for details on how to customize the default table columns.

{pstd}
The default column labels are the column names, and the default formats are
{cmd:%7.4g} for {cmd:alpha} and {cmd:power} and {cmd:%7.0g} for {cmd:N}.
These and other settings controlling the look of the default table can be
changed as described in
{it:{help power_userwritten##usertablelabs:Modifying the look of the default table}}.

{pstd}
You can always use the {cmd:table()} option to customize your table.  However,
if you want to modify how the table looks by default, you need to follow the
steps described in the following sections:

{phang2}{help power_userwritten##usertablecols:Setting supported columns}{p_end}
{phang2}{help power_userwritten##usertabletabcols:Modifying the default table columns}{p_end}
{phang2}{help power_userwritten##usertablelabs:Modifying the look of the default table}{p_end}
{phang2}{help power_userwritten##usertableex:Example continued}{p_end}


{marker usertablecols}{...}
    {title:Setting supported columns}

{marker supported}{...}
{pstd}
The {cmd:power} command automatically supports a number of columns such as
{cmd:alpha}, {cmd:beta}, {cmd:power}, {cmd:N}, etc.  The supported
columns are the columns that can be accessed within {cmd:power}'s
options {cmd:table()} and {cmd:graph()}.

{marker pss_colnames}{...}
{pstd}
Most of the time you will have additional columns, {it:usercolnames}, which
you will want {cmd:power} to support.  To make {cmd:power} recognize the
columns as supported columns, you must list the names of the additional
columns, {it:usercolnames}, in an s-class macro {cmd:s(pss_colnames)} in the
{help power_userwritten##initializer:initializer}.  Columns {it:usercolnames}
will then be added to {cmd:power}'s list of supported columns.  Columns
{it:usercolnames} will also be displayed in the default table unless 
{helpb power_userwritten##pss_tabcolnames:s(pss_tabcolnames)} or 
{helpb power_userwritten##pss_alltabcolnames:s(pss_alltabcolnames)} is set.

{marker pss_allcolnames}{...}
{pstd}
If you want to reset {cmd:power}'s list of supported columns, that is, to
specify all the supported columns manually, you should use the
{cmd:s(pss_allcolnames)} macro.  The supported columns will then include only
the ones you listed in the macro.  If you specify {cmd:s(pss_allcolnames)},
you must remember to include {cmd:power}'s main columns {cmd:N}, {cmd:power},
and {cmd:beta} in your list.  Otherwise, you may not be able to utilize some
of {cmd:power}'s functionality, such as default graphs.  If
{cmd:s(pss_colnames)} is specified together with {cmd:s(pss_allcolnames)}, the
former will be ignored.  The specified supported columns will be automatically
displayed in the default table unless 
{helpb power_userwritten##pss_alltabcolnames:s(pss_alltabcolnames)} is set.

{pstd}
The values corresponding to the specified columns must be stored by the 
{help power_userwritten##evaluator:evaluator} in {cmd:r()} scalars with the
same names as the column names.  For example, the value for column {cmd:alpha}
is stored in {cmd:r(alpha)}, the value for column {cmd:power} is stored in
{cmd:r(power)}, and the value for column {cmd:N} is stored in {cmd:r(N)}.

{pstd}
Any column not listed in {cmd:s(pss_colnames)} or {cmd:s(pss_allcolnames)}
will not be available within the {cmd:power} command.  For example, any
reference to such a column within {cmd:power}'s options {cmd:table()} and
{cmd:graph()} will result in an error.


{marker usertabletabcols}{...}
    {title:Modifying the default table columns}

{marker pss_tabcolnames}{...}
{marker pss_alltabcolnames}{...}
{pstd}
By default, {cmd:power} displays the specified 
{help power_userwritten##supported:supported columns}.  If you want to display
only a subset of those columns, you can use either {cmd:s(pss_tabcolnames)} or
{cmd:s(pss_alltabcolnames)} to specify the columns to be displayed.  You
specify additional columns to be displayed in {cmd:s(pss_tabcolnames)} and a
complete list of the displayed columns in {cmd:s(pss_alltabcolnames)}.  If you
specify {cmd:s(pss_tabcolnames)}, the displayed columns will include
{cmd:alpha}, {cmd:power}, or {cmd:beta} (whichever is specified with the
command), {cmd:N}, and the additional columns you specified.  If you specify
{cmd:s(pss_alltabcolnames)}, only the columns listed in this macro will be
displayed.  One situation when you may want to do this is if you want to
change the order in which the columns are displayed by default.  If you
specify both macros, {cmd:s(pss_tabcolnames)} will be ignored.  You can
specify the names of only 
{help power_userwritten##supported:supported columns} in these macros.


{marker usertablelabs}{...}
    {title:Modifying the look of the default table}

{marker pss_collabels}{...}
{pstd}
The default table column labels are the column names.  You can change this by
specifying your own column labels in the {cmd:s(pss_collabels)} macro.  The
labels must be properly quoted if they contain spaces or quotes.  The labels
must be specified for all columns listed in 
{helpb power_userwritten##pss_colnames:s(pss_colnames)} or 
{helpb power_userwritten##pss_allcolnames:s(pss_allcolnames)}.

{marker pss_colformats}{...}
{pstd}
The default column formats are {cmd:%7.0g} for sample sizes and {cmd:%7.4g}
for all other columns.  You can change this by specifying your own column
formats in the {cmd:s(pss_colformats)} macro.  The formats must be quoted and
must be specified for all columns listed in 
{helpb power_userwritten##pss_colnames:s(pss_colnames)} or 
{helpb power_userwritten##pss_allcolnames:s(pss_allcolnames)}.

{marker pss_colwidths}{...}
{pstd}
The default column widths are the widths of the default formats plus one.  You
can specify your own column widths in the {cmd:s(pss_colwidths)} macro.  The
widths must be specified for all columns listed in 
{helpb power_userwritten##pss_colnames:s(pss_colnames)} or 
{helpb power_userwritten##pss_allcolnames:s(pss_allcolnames)}.


{marker usertableex}{...}
    {title:Example continued}

{marker initexample}{...}
{pstd}
Continuing our {cmd:myztest} {help power_userwritten##introex:example}, we
want to add a column containing the specified standardized differences to the
list of supported columns.  The specified standardized difference is stored in
{cmd:r(stddiff)} in the {cmd:myztest} evaluator, so the name of our column is
{cmd:stddiff}.  We specify it in {cmd:s(pss_colnames)} in our initializer.

{p 12 18 2}// initializer{p_end}
{p 12 18 2}{cmd:program power_cmd_myztest_init, sclass}{p_end}
{p 20 26 2}{cmd:version 13.1}{p_end}
{p 20 26 2}{cmd:sreturn clear}{p_end}
{p 20 26 2}{cmd:sreturn local pss_numopts "STDDiff"}{p_end}
{p 20 26 2}{cmd:sreturn local pss_colnames "stddiff"}  // <-- new line{p_end}
{p 12 18 2}{cmd:end}{p_end}

{pstd}
We rerun our command now and see that the {cmd:stddiff} column is added to the
default table:

{phang2}{cmd:. power myztest, alpha(0.05) n(10) stddiff(0.25)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt}{ralign 8:stddiff}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1211}{res}{ralign 8:10}{res}{ralign 8:.25}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c BRC}

{pstd}
We can also change the default column label of the {cmd:stddiff} column to
"Std. Difference".  Note that we can do this within {cmd:power}'s option
{helpb power_opttable:table()}, but if we want this label to show up
automatically in the default table, we should specify it in the initializer.
We specify the column label in the {cmd:s(pss_collabels)} macro.

{p 12 18 2}// initializer{p_end}
{p 12 18 2}{cmd:program power_cmd_myztest_init, sclass}{p_end}
{p 20 26 2}{cmd:version 13.1}{p_end}
{p 20 26 2}{cmd:sreturn clear}{p_end}
{p 20 26 2}{cmd:sreturn local pss_numopts "STDDiff"}{p_end}
{p 20 26 2}{cmd:sreturn local pss_colnames "stddiff"}{p_end}
{p 20 26 2}{cmd:sreturn local pss_collabels `""Std. Difference""'}  // <-- new line{p_end}
{p 12 18 2}{cmd:end}{p_end}

{pstd}
The column containing standardized differences now has the new label

{phang2}{cmd:. power myztest, alpha(0.05) n(10) stddiff(0.25)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 16}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt}{ralign 16:Std. Difference}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 16}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.1211}{res}{ralign 8:10}{res}{ralign 16:.25}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 16}{txt}{txt}{hline 1}{c BRC}


{marker usergraph}{...}
{title:Customizing default graphs}

{pstd}
By default, {cmd:power} plots the estimated power on the y axis and the
specified sample size on the x axis or the estimated sample size on the
y axis and the specified power on the x axis.  If 
{helpb power_userwritten##pss_target:s(pss_target)} is specified, the estimated
sample size is plotted against the specified target parameter.  For
effect-size computation, the target parameter must be specified in 
{helpb power_userwritten##pss_target:s(pss_target)}, and it is plotted on
the x axis against the specified sample size.  See 
{manhelp power_optgraph PSS:power, graph} for details about other default
settings.

{marker pss_colgrlabels}{...}
{pstd}
You can overwrite the default column labels displayed on the graph by
specifying the {cmd:s(pss_colgrlabels)} macro.  The specification of the graph
labels is the same as the specification of
{help power_userwritten##pss_collabels:table column labels}.

{marker pss_colgrsymbols}{...}
{pstd}
You can also overwrite the default symbols that are used on the graph to
label the results by specifying the new {help text:symbols} in the macro
{cmd:s(pss_colgrsymbols)}.  The symbols must be specified for all columns
listed in {helpb power_userwritten##pss_colnames:s(pss_colnames)} or 
{helpb power_userwritten##pss_allcolnames:s(pss_allcolnames)}.


{marker userother}{...}
{title:Other settings}

{marker pss_delta}{...}
{marker pss_notabdelta}{...}
{pstd}
When you add your own method to {cmd:power}, the effect-size parameter is not
defined.  You can define it yourself by specifying the name of the column
containing the values of the effect-size parameter in the {cmd:s(pss_delta)}
macro.  The effect-size parameter can then be accessed by using the column
name {cmd:delta} and will be displayed in the default table as {cmd:delta}
unless the {cmd:s(pss_notabdelta)} macro is set to {cmd:notabdelta}.

{marker pss_target}{...}
{pstd}
The {help pss_glossary##def_target:target parameter} is not set by {cmd:power}
for newly added methods.  You can set it yourself by specifying the name of
the column containing the values of the target parameter in the
{cmd:s(pss_target)} macro.  You must set this macro if you want to obtain
default graphs for effect-size determination.  The target parameter can then
be accessed by using the column name {cmd:target}.

{marker pss_targetlabel}{...}
{pstd}
If the {help power_userwritten##pss_target:target parameter} is set in the
{cmd:s(pss_target)} macro, you can also specify its label in
{cmd:s(pss_targetlabel)}.  This label will be used in the title for the
effect-size determination and as the axis label for the graph column
{cmd:target}.

{marker pss_argnames}{...}
{pstd}
If your method supports command arguments, the arguments specified directly
following the method name, you can specify their corresponding column names in
the {cmd:s(pss_argnames)} macro.  You can then refer to these arguments as
{cmd:arg1}, {cmd:arg2}, and so on, when producing tables or graphs.

{marker pss_titletest}{...}
{pstd}
{cmd:power} {it:usermethod} uses the following generic titles: "Estimated
sample size" for sample-size determination, "Estimated power" for power
determination, and "Estimated target parameter" for effect-size determination.
You can extend these titles to be more specific to your method by adding text
in the {cmd:s(pss_titletest)} macro.  For example, if {cmd:s(pss_titletest)}
contains "for my test", the resulting titles will be "Estimated sample size
for my test", "Estimated power for my test", and "Estimated target parameter
for my test".  Also see 
{helpb power_userwritten##pss_targetlabel:s(pss_targetlabel)} for how to
include a label for the target parameter in the title.

{marker pss_subtitle}{...}
{pstd}
{cmd:power} {it:usermethod} uses the following generic subtitles: "Two-sided
test" for a two-sided test or "One-sided test" for a one-sided test when
option {cmd:onesided} is specified.  You can change the default subtitle by
specifying the {cmd:s(pss_subtitle)} macro.

{marker pss_hyp_lhs}{...}
{marker pss_hyp_rhs}{...}
{marker pss_grhyp_lhs}{...}
{marker pss_grhyp_rhs}{...}
{pstd}
Optionally, {cmd:power} {it:usermethod} can display a hypothesis statement if
macros {cmd:s(pss_hyp_lhs)} and {cmd:s(pss_hyp_rhs)} are specified.
{cmd:s(pss_hyp_lhs)} must contain the parameter of interest, and
{cmd:s(pss_hyp_rhs)} will typically contain the null or comparison value.  For
example, if {cmd:s(pss_hyp_lhs)} contains {cmd:beta1} and {cmd:s(pss_hyp_rhs)}
contains {cmd:0}, {cmd:power} {it:usermethod} will display

{phang2}
    Ho: beta1 = 0  versus  Ha: beta1 != 0

{pstd}
for a two-sided test and

{phang2}
    Ho: beta1 = 0, one-sided alternative

{pstd}
for a one-sided test.  The same hypotheses will appear on the graph, unless
{cmd:s(pss_grhyp_lhs)} and {cmd:s(pss_grhyp_rhs)} are specified.  These macros
are useful if you want to include parameters as symbols on the graph. In our
example, we could have defined {cmd:s(pss_grhyp_lhs)} as {cmd:{&beta}{sub:1}}
and {cmd:s(pss_grhyp_rhs)} as {cmd:0} to include "beta1" as the corresponding
symbol on the graph; see {help graph_text:{it:Text in graphs}}.


{marker userparse}{...}
{title:Handling parsing more efficiently}

{pstd}
The {cmd:power} command checks its {help power##power_options:common options},
but you are responsible for checking your method-specific options,
{it:useropts}, or their interaction with {cmd:power}'s common options.  You
can certainly do this in your {help power_userwritten##evaluator:evaluator}.
The checks, however, will then be performed each time your evaluator is
called.  You can instead perform all of your checks once within the 
{help power_userwritten##parser:parser}.

{pstd}
Your parser may be an s-class command and set any of the 
{help power_userwritten##sresults:{bf:s()} results} typically specified in the
initializer.  This may be useful, for example, for building the columns
displayed in the default table dynamically, depending on which options were
specified.  If all desired {cmd:s()} results are set in the parser, you do not
need an initializer.


{marker moreexamples}{...}
{title:More examples: Adding two-sample methods}

{pstd}
All of our examples so far showed how to add a one-sample method to the
{cmd:power} command.  Here we demonstrate how to add a two-sample method.
(The support for multiple-sample methods is not yet available.)

{pstd}
The steps for adding your own two-sample methods are the same as those for
adding one-sample methods, except you must also specify the
{cmd:twosample} option with the {cmd:power} command.  This option requests
that {cmd:power} allow the specification of its two-sample options such as
{cmd:n1()}, {cmd:n2()}, and {cmd:nratio()}.

{pstd}
For illustration, let's add a method comparing two independent
proportions using a large-sample chi-squared test. (Note that this method is
available in the official {helpb power_twoproportions:power twoproportions}
command.)  For simplicity, we will compute the power of a two-sided test.  We
will call our new method {cmd:powertwoprop}.

{pstd}
We write our evaluator and save it as {cmd:power_cmd_powertwoprop.ado}.

{p 12 18 2}// evaluator{p_end}
{p 12 18 2}{cmd:program power_cmd_powertwoprop, rclass}{p_end}
{p 20 26 2}{cmd:version 13.1}{p_end}
                    //parse command arguments and options
                    {cmd:syntax anything(id="proportions"),}       ///
                           [ {cmd:Alpha(real 0.05)}       /// significance level
                             {cmd:n(string)}              /// total sample size
                             {cmd:n1(string) n2(string)}  /// group sample sizes
                             {cmd:NRATio(real 1)}         /// N2/N1
                           ]
                    //parse specification of proportions
                    {cmd:gettoken p1 rest : anything}
                    {cmd:gettoken p2 rest : rest}
                    {cmd:if (`"`p2'"'=="") {c -(}}
                            {cmd:di as err "Experimental-group proportion must be specified"}
                            {cmd:exit 198}
                    {cmd:{c )-}}
                    {cmd:if (`"`rest'"'!="") {c -(}}
                            {cmd:di as err "Only two proportions may be specified"}
                            {cmd:exit 198}
		    {cmd:{c )-}}
                    //sample size must be specified to compute power
                    {cmd:if (`"`n'`n1'`n2'"'=="") {c -(}}
                            {cmd:di as err "One of {bf:n()}, {bf:n1()}, or {bf:n2()} "} ///
                                      {cmd:"is required to compute power"}
                            {cmd:exit 198}
		    {cmd:{c )-}}
                    //handle various sample-size specifications
                    {cmd:if (`"`n'"'=="") {c -(}}
                            {cmd:tempname n}
                            {cmd:if (`"`n2'"'=="") {c -(}}
                                    {cmd:tempname n2}
                                    {cmd:scalar `n2' = ceil(`nratio'*`n1')}
		            {cmd:{c )-}}
                            {cmd:else {c -(}}
                                    {cmd:tempname n1}
                                    {cmd:scalar `n1' = ceil(`n2'/`nratio')}
		            {cmd:{c )-}}
                            {cmd:scalar `n' = `n1'+`n2'}
		    {cmd:{c )-}}
                    {cmd:else {c -(}}
                            {cmd:tempname n1 n2}
                            {cmd:scalar `n1' = ceil(`n'/(1+`nratio'))}
                            {cmd:scalar `n2' = `n'-`n1'}
		    {cmd:{c )-}}

                    //compute power
                    {cmd:tempname diff pbar sigma_D sigma_p crv power}
                    {cmd:scalar    `diff' = `p2' - `p1'}
                    {cmd:scalar    `pbar' = (`n1'*`p1'+`n2'*`p2')/`n'}
                    {cmd:scalar `sigma_D' = sqrt(`p1'*(1-`p1')/`n1'+`p2'*(1-`p2')/`n2')}
                    {cmd:scalar `sigma_p' = sqrt(`pbar'*(1-`pbar')*(1/`n1'+1/`n2'))}
                    {cmd:scalar     `crv' = invnormal(1-`alpha'/2)*`sigma_p'}
                    {cmd:scalar   `power' = normal((`diff'-`crv')/`sigma_D')} ///
                                       {cmd:+ normal((-`diff'-`crv')/`sigma_D')}

{p 20 26 2}//return results{p_end}
{p 20 26 2}{cmd:return scalar alpha   = `alpha'}{p_end}
{p 20 26 2}{cmd:return scalar power   = `power'}{p_end}
{p 20 26 2}{cmd:return scalar N       = `n'}{p_end}
{p 20 26 2}{cmd:return scalar N1      = `n1'}{p_end}
{p 20 26 2}{cmd:return scalar N2      = `n2'}{p_end}
{p 20 26 2}{cmd:return scalar nratio  = `nratio'}{p_end}
{p 20 26 2}{cmd:return scalar p1      = `p1'}{p_end}
{p 20 26 2}{cmd:return scalar p2      = `p2'}{p_end}
{p 12 18 2}{cmd:end}{p_end}

{pstd}
We can now use {cmd:powertwoprop} with the {cmd:power} command.  We specify
the two proportions following the command name and group sample sizes in
options {cmd:n1()} and {cmd:n2()}.  We also specify the
{cmd:twosample} option so that {cmd:power} allows the specification of
two-sample options {cmd:n1()} and {cmd:n2()}.

{phang2}{cmd:. power powertwoprop 0.1 0.3, twosample n1(50) n2(50)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.7115}{res}{ralign 8:100}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c BRC}

{pstd}
As with one-sample methods, we can use an initializer (saved in
{cmd:power_cmd_powertwoprop_init.ado}) to include additional columns in our
default table.

{p 12 18 2}// initializer{p_end}
{p 12 18 2}{cmd:program power_cmd_powertwoprop, sclass}{p_end}
{p 20 26 2}{cmd:version 13.1}{p_end}
{p 20 26 2}{cmd:sreturn clear}{p_end}
{p 20 26 2}{cmd:sreturn local pss_colnames "N1 N2 nratio p1 p2"}{p_end}
{p 12 18 2}{cmd:end}{p_end}

{phang2}{cmd:. power powertwoprop 0.1 0.3, twosample n1(50) n2(50)}{p_end}
{res}
{p 8 10 2}{txt}Estimated power{p_end}{txt}{p 8 10 2}Two-sided test{p_end}

          {txt}{c TLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c TRC}
          {txt}{c |}{txt}{txt}{ralign 8:alpha}{txt}{txt}{ralign 8:power}{txt}{txt}{ralign 8:N}{txt}{txt}{ralign 8:N1}{txt}{txt}{ralign 8:N2}{txt}{txt}{ralign 8:nratio}{txt}{txt}{ralign 8:p1}{txt}{txt}{ralign 8:p2}{txt}{txt} {c |}
          {txt}{c LT}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c RT}
          {txt}{c |}{res}{ralign 8:.05}{res}{ralign 8:.6743}{res}{ralign 8:100}{res}{ralign 8:40}{res}{ralign 8:60}{res}{ralign 8:1.5}{res}{ralign 8:.1}{res}{ralign 8:.3}{txt} {c |}
          {txt}{c BLC}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 8}{txt}{txt}{hline 1}{c BRC}


{marker sresults}{...}
{title:Initializer's s() return settings}

{pstd}
The following {cmd:s()} results may be set by the 
{help power_userwritten##initializer:initializer} or 
{help power_userwritten##parser:parser}:

{synoptset 23 tabbed}{...}
{p2col 5 23 27 2: Macros}{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_colnames:pss_colnames}{cmd:)}}columns to be added to the default supported columns{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_allcolnames:pss_allcolnames}{cmd:)}}all supported columns{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_tabcolnames:pss_tabcolnames}{cmd:)}}columns to be added to the default table{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_alltabcolnames:pss_alltabcolnames}{cmd:)}}all columns to be displayed in the default table{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_collabels:pss_collabels}{cmd:)}}labels for the specified columns{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_colformats:pss_colformats}{cmd:)}}formats for the specified columns{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_colwidths:pss_colwidths}{cmd:)}}widths for the specified columns{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_colgrlabels:pss_colgrlabels}{cmd:)}}labels to be used to label columns on the graph{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_colgrsymbols:pss_colgrsymbols}{cmd:)}}symbols to be used to label columns on the graph{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_delta:pss_delta}{cmd:)}}column name containing the effect-size parameter{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_target:pss_target}{cmd:)}}column name containing the target parameter{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_targetlabel:pss_targetlabel}{cmd:)}}label for the target parameter{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_argnames:pss_argnames}{cmd:)}}column names containing command arguments{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_titletest:pss_titletest}{cmd:)}}method-specific title{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_subtitle:pss_subtitle}{cmd:)}}subtitle{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_hyp_lhs:pss_hyp_lhs}{cmd:)}}left-hand-side parameter or value for the hypothesis{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_hyp_rhs:pss_hyp_rhs}{cmd:)}}right-hand-side parameter or value for the hypothesis{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_grhyp_lhs:pss_grhyp_lhs}{cmd:)}}left-hand-side or value parameter for the hypothesis on the graph{p_end}
{synopt:{cmd:s(}{helpb power_userwritten##pss_grhyp_rhs:pss_grhyp_rhs}{cmd:)}}right-hand-side parameter or value for the hypothesis on the graph{p_end}
{p2colreset}{...}
