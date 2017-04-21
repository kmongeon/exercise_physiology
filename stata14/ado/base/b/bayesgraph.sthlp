{smcl}
{* *! version 1.0.4  04may2015}{...}
{viewerdialog bayesgraph "dialog bayesgraph"}{...}
{vieweralsosee "[BAYES] bayesgraph" "mansection BAYES bayesgraph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] bayesmh postestimation" "help bayesmh postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats ess" "help bayesstats ess"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{vieweralsosee "[G-2] graph matrix" "help graph matrix"}{...}
{vieweralsosee "[G-2] graph twoway kdensity" "help graph twoway kdensity"}{...}
{vieweralsosee "[R] histogram" "help histogram"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[TS] corrgram" "help corrgram"}{...}
{vieweralsosee "[TS] tsline" "help tsline"}{...}
{viewerjumpto "Syntax" "bayesgraph##syntax"}{...}
{viewerjumpto "Menu" "bayesgraph##menu"}{...}
{viewerjumpto "Description" "bayesgraph##description"}{...}
{viewerjumpto "Remarks" "bayesgraph##remarks"}{...}
{viewerjumpto "Examples" "bayesgraph##examples"}{...}
{title:Title}

{p2colset 5 27 27 2}{...}
{p2col :{manlink BAYES bayesgraph} {hline 2}}Graphical summaries and convergence diagnostics{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Graphical summaries and convergence diagnostics for single parameter

{p 8 11 2}
{opt bayesgraph} {it:{help bayesgraph##graph:graph}} {it:{help bayesgraph##scalar_param:scalar_param}} [{cmd:,} 
{it:{help bayesgraph##singleopts:singleopts}}] 


{phang}
Graphical summaries and convergence diagnostics for multiple parameters

{p 8 11 2}
{opt bayesgraph} {it:{help bayesgraph##graph:graph}} {it:{help bayesgraph##scalar_param:spec}} [{it:{help bayesgraph##scalar_param:spec}} ...] [{cmd:,} 
{it:{help bayesgraph##multiopts:multiopts}}] 

{p 8 11 2}
{opt bayesgraph matrix} {it:{help bayesgraph##scalar_param:spec}} {it:{help bayesgraph##scalar_param:spec}} [{it:{help bayesgraph##scalar_param:spec}} ...] [{cmd:,} 
{it:{help bayesgraph##singleopts:singleopts}}] 


{phang}
Graphical summaries and convergence diagnostics for all parameters 

{p 8 11 2}
{opt bayesgraph} {it:{help bayesgraph##graph:graph}} {cmd:_all} [{cmd:,} 
{it:{help bayesgraph##multiopts:multiopts}}] 


{synoptset 16}{...}
{marker graph}{...}
{synopthdr:graph}
{synoptline}
{synopt :{opt diag:nostics}}multiple diagnostics in compact form{p_end}
{synopt :{opt trace}}trace plots{p_end}
{synopt :{opt ac}}autocorrelation plots{p_end}
{synopt :{opt hist:ogram}}histograms{p_end}
{synopt :{opt kdens:ity}}density plots{p_end}
{synopt :{opt cusum}}cumulative sum plots{p_end}
{synopt :{opt matrix}}scatterplot matrix{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:bayesgraph matrix} requires at least two parameters.{p_end}

{marker scalar_param}{...}
{p 8 11 2}
{it:scalar_param} is a {help bayes_glossary##scalar_model_parameter:scalar model parameter} specified as 
{cmd:{c -(}}{cmd:param}{cmd:{c )-}} or 
{cmd:{c -(}}{cmd:eqname:param}{cmd:{c )-}} or an expression {it:exprspec} of
scalar model parameters.  Matrix model parameters are not allowed, but you may
refer to their individual elements.

{p 8 11 2}
{it:exprspec} is an optionally labeled expression of model parameters
specified in parentheses:

{p 12 15 2}
{cmd:(}[{it:exprlabel}{cmd::}]{it:expr}{cmd:)}

{p 11 11 2}
{it:exprlabel} is a valid Stata name and expr is a scalar expression
which may not contain matrix model parameters.  See 
{it:{mansection BAYES bayesmhpostestimationRemarksandexamplesSpecifyingfunctionsofmodelparameters:Specifying functions of model parameters}} in {bf:[BAYES] bayesmh postestimation} for
examples.

{p 8 11 2}
{it:spec} is either {it:scalar_param} or {it:exprspec}.

{synoptset 25 tabbed}{...}
{marker singleopts}{...}
{synopthdr:singleopts}
{synoptline}
{syntab:Options}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample; default is {cmd:skip(0)}{p_end}
{synopt :{cmd:name(}{it:name}{cmd:,} ...{cmd:)}}specify name of graph{p_end}
{synopt :{cmd:saving(}{it:{help filename}}{cmd:,} ...{cmd:)}}save graph in file{p_end}
{synopt :{it:{help bayesgraph##graphopts:graphopts}}}graph-specific
options{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 30}{...}
{marker multiopts}{...}
{synopthdr:multiopts}
{synoptline}
{synopt :{opt byparm}[{cmd:(}{it:{help graph_by##byopts:grbyparmopts}}{cmd:)}]}specify to display plots on one graph; default is a separate graph for each plot; not allowed with graphs {cmd:diagnostics} or {cmd:matrix} or with option 
{cmd:combine()}{p_end}
{synopt :{opt combine}[{cmd:(}{it:{help graph_combine##options:grcombineopts}}{cmd:)}]}specify to display plots on one graph; 
recommended when the number of parameters is large; not allowed with graphs {cmd:diagnostics} or {cmd:matrix} or with option {cmd:byparm()}{p_end}
{synopt :{opt sleep(#)}}pause for {it:#} seconds between multiple graphs; default
is {cmd:sleep(0)}{p_end}
{synopt :{opt wait}}pause until the {hline 2}{cmd:more}{hline 2} condition is cleared{p_end}
{synopt :[{opt no}]{opt close}}(do not) close Graph windows
when the next graph is displayed with multiple graphs;
default is {cmd:noclose}{p_end}
{synopt :{opt skip(#)}}skip every {it:#} observations from the MCMC sample;
default is {cmd:skip(0)}{p_end}
{synopt :{opt name}{cmd:(}{it:{help bayesgraph##namespec:namespec}}{cmd:,} ...{cmd:)}}specify names of graphs{p_end}
{synopt :{opt saving}{cmd:(}{it:{help bayesgraph##filespec:filespec}}{cmd:,} ...{cmd:)}}save graphs in file{p_end}
{synopt :{cmd:graphopts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}}control the look of all graphs; not
allowed with {cmd:byparm()}{p_end}
{synopt :{opt graph}[{it:#}]{cmd:opts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}}control the look of {it:#}th graph;
not allowed with {cmd:byparm()}{p_end}
{synopt :{it:{help bayesgraph##graphopts:graphopts}}}equivalent to {cmd:graphopts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}; only one
may be specified{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 16}{...}
{marker graphopts}{...}
{synopthdr:graphopts}
{synoptline}
{synopt :{it:{help bayesgraph##diagopts:diagnosticsopts}}}options for {cmd:bayesgraph diagnostics}{p_end}
{synopt :{it:{help tsline##tsline_options:tslineopts}}}options for {cmd:bayesgraph trace} and {cmd:bayesgraph cusum}{p_end}
{synopt :{it:{help ac##ac_options:acopts}}}options for {cmd:bayesgraph ac}{p_end}
{synopt :{it:{help hist##options:histopts}}}options for {cmd:bayesgraph histogram}{p_end}
{synopt :{it:{help bayesgraph##kdens_opts:kdensityopts}}}options for {cmd:bayesgraph kdensity}{p_end}
{synopt :{it:{help graph_matrix##options:grmatrixopts}}}options for {cmd:bayesgraph matrix}{p_end}
{synoptline}

{synoptset 30}{...}
{marker diagopts}{...}
{synopthdr:diagnosticsopts}
{synoptline}
{synopt :{cmd:traceopts(}{it:{help tsline##tsline_options:tslineopts}}{cmd:)}}affect rendition of all trace
plots{p_end}
{synopt :{opt trace}[{it:#}]{cmd:opts(}{it:{help tsline##tsline_options:tslineopts}}{cmd:)}}affect rendition of {it:#}th trace
plot{p_end}
{synopt :{cmd:acopts(}{it:{help ac##ac_options:acopts}}{cmd:)}}affect rendition of all autocorrelation plots{p_end}
{synopt :{opt ac}[{it:#}]{cmd:opts(}{it:{help ac##ac_options:acopts}}{cmd:)}}affect rendition of {it:#}th autocorrelation
plot{p_end}
{synopt :{cmd:histopts(}{it:{help hist##options:histopts}}{cmd:)}}affect
rendition of all histogram plot{p_end}
{synopt :{opt hist}[{it:#}]{cmd:opts(}{it:{help hist##options:histopts}}{cmd:)}}affect rendition of {it:#}th histogram{p_end}
{synopt :{cmd:kdensopts(}{it:{help bayesgraph##kdens_opts:kdensityopts}}{cmd:)}}affect rendition of all density
plots{p_end}
{synopt :{opt kdens}[{it:#}]{cmd:opts(}{it:{help bayesgraph##kdens_opts:kdensityopts}}{cmd:)}}affect rendition of {it:#}th density
plot{p_end}
{synopt :{it:{help graph_combine##options:grcombineopts}}}any option
documented in {manhelp graph_combine G-2:graph combine}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 16}{...}
{marker ac_options}{...}
{synopthdr:acopts}
{synoptline}
{synopt :{cmd:ci}}plot autocorrelations with confidence intervals; not allowed
with {cmd:byparm()}{p_end}
{synopt :{it:{help ac##ac_options:acopts}}}any options other than {cmd:generate()} documented for the {cmd:ac} command in {helpb corrgram}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25}{...}
{marker kdens_opts}{...}
{synopthdr:kdensityopts}
{synoptline}
{synopt :{it:{help kdensity##options:kdensopts}}}options for the overall kernel density plot{p_end}
{synopt :{cmd:show(}{it:{help bayesgraph##showspec:showspec}}{cmd:)}}show first-half density, second-half density, or both; default is {cmd:both}{p_end}
{synopt :{opt kdensfirst}{cmd:(}{it:{help kdensity##options:kdens1opts}}{cmd:)}}affect rendition of the first-half density plot{p_end}
{synopt :{opt kdenssecond}{cmd:(}{it:{help kdensity##options:kdens2opts}}{cmd:)}}affect rendition of the second-half density plot{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Graphical summaries}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayesgraph} provides graphical summaries and convergence diagnostics for
simulated posterior distributions (MCMC samples) of model parameters and
functions of model parameters obtained from the {cmd:bayesmh} command.
Graphical summaries include trace plots, autocorrelation plots, and various
distributional plots.


{marker options}{...}
{title:Options}

{phang}
{cmd:byparm}[{cmd:(}{it:grbyparmopts}{cmd:)}] specifies the display of all
plots of parameters as subgraphs on one graph.  By default, a separate graph
is produced for each plot when multiple parameters are specified.  This option
is not allowed with {cmd:bayesgraph diagnostics} or {cmd:bayesgraph}
{cmd:matrix} and may not be combined with option {cmd:combine()}.  When many
parameters or expressions are specified, this option may fail because of
memory constraints.  In that case, you may use option {cmd:combine()} instead.

{pmore}
{it:{help by_option##byopts:grbyparmopts}} is any of the
suboptions of {cmd:by()} documented in {manlinki G-3 by_option}.

{pmore}
{cmd:byparm()} allows y scales to differ for all graph types and forces x
scales to be the same only for {cmd:bayesgraph trace} and {cmd:bayesgraph}
{cmd:cusum}.  Use {cmd:noyrescale} within {cmd:byparm()} to specify a common y
axis, and use {cmd:xrescale} or {cmd:noxrescale} to change the default
behavior for the x axis.

{pmore}
{cmd:byparm()} with {cmd:bayesgraph trace} and {cmd:bayesgraph cusum} defaults
to displaying multiple plots in one column to accommodate the x axis with many
iterations.  Use {cmd:norowcoldefault} within {cmd:byparm()} to switch back to
the default behavior of options {cmd:rows()} and {cmd:cols()} of the 
{manlinki G-3 by_option}.

{phang}
{cmd:combine}[{cmd:(}{it:grcombineopts}{cmd:)}] specifies the display of all
plots of parameters as subgraphs on one graph and is an alternative to
{cmd:byparm()} with a large number of parameters.  By default, a separate
graph is produced for each plot when multiple parameters are specified.  This
option is not allowed with {cmd:bayesgraph diagnostics} or {cmd:bayesgraph}
{cmd:matrix} and may not be combined with option {cmd:byparm()}.  It can be
used in cases where a large number of parameters or expressions are specified
and the {cmd:byparm()} option would cause an error because of memory
constraints.

{pmore}
{it:grcombineopts} is any of the options documented in {helpb graph combine}.

{phang}
{opt sleep(#)} specifies pausing for {it:#} seconds before producing the next
graph.  This option is allowed only when multiple parameters are specified.
This option may not be combined with {cmd:wait}, {cmd:combine()}, or
{cmd:byparm()}.

{phang}
{cmd:wait} causes {cmd:bayesgraph} to display {hline 2}{cmd:more}{hline 2} and
pause until any key is pressed before producing the next graph.  This option
is allowed when multiple parameters are specified.  This option may not be
combined with {cmd:sleep()}, {cmd:combine()}, or {cmd:byparm()}.
{cmd:wait} temporarily ignores the global setting that is specified using
{cmd:set more off}.

{phang}
[{cmd:no}]{cmd:close} specifies that, for multiple graphs, the Graph window be
closed when the next graph is displayed.  The default is {cmd:noclose} or to
not close any Graph windows.

{phang}
{opt skip(#)} specifies that every {it:#} observations from the MCMC sample
not be used for computation.  The default is {cmd:skip(0)} or to use all
observations in the MCMC sample.  Option {cmd:skip()} can be used to subsample
or thin the chain.  {opt skip(#)} is equivalent to a thinning interval of
{it:#}+1.  For example, if you specify {cmd:skip(1)}, corresponding to the
thinning interval of 2, the command will skip every other observation in the
sample and will use only observations 1, 3, 5, and so on in the computation.
If you specify {cmd:skip(2)}, corresponding to the thinning interval of 3, the
command will skip every 2 observations in the sample and will use only
observations 1, 4, 7, and so on in the computation.  {cmd:skip()} does not thin
the chain in the sense of physically removing observations from the sample, as
is done by {cmd:bayesmh}'s {cmd:thinning()} option.  It only discards selected
observations from the computation and leaves the original sample unmodified.

{marker namespec}{...}
{phang}
{cmd:name(}{it:namespec}[{cmd:, replace)} specifies the name of the graph or
multiple graphs.  See {manlinki G-3 name_option} for a single graph.  If
multiple graphs are produced, then the argument of {cmd:name()} is either a
list of names or a {it:stub}, in which case graphs are named {it:stub}{cmd:1},
{it:stub}{cmd:2}, and so on.  With multiple graphs, if {cmd:name()} is not
specified and neither {cmd:sleep()} nor {cmd:wait} is specified,
{cmd:name(Graph__{it:#}, replace)} is assumed, and thus the produced graphs
may be replaced by subsequent {cmd:bayesgraph} commands.

{pmore}
The {cmd:replace} suboption causes existing graphs with the specified name or
names to be replaced.

{marker filespec}{...}
{phang}
{cmd:saving(}{it:filespec}[{cmd:, replace)} specifies the filename or
filenames to use to save the graph or multiple graphs to disk.  See
{manhelpi saving_option G-3} for a single graph.  If multiple graphs are
produced, then the argument of {cmd:saving()} is either a list of filenames or
a {it:stub}, in which case graphs are saved with filenames {it:stub}{cmd:1},
{it:stub}{cmd:2}, and so on.

{pmore}
The {cmd:replace} suboption specifies that the file (or files) may be replaced
if it already exists.

{phang}
{cmd:graphopts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)} and
{cmd:graph}[{it:#}]{cmd:opts(}{it:{help bayesgraph##graphopts:graphopts}}{cmd:)}
affect the rendition of graphs.  {cmd:graphopts()} affects the rendition of
all graphs but may be overridden for specific graphs by using the
{cmd:graph}{it:#}{cmd:opts()} option.  The options specified within
{cmd:graph}{it:#}{cmd:opts()} are specific for each type of graph.

{pmore}
The two specifications

{p 12 15 2}
{cmd:bayesgraph} ...{cmd:, graphopts(}{it:graphopts}{cmd:)}

{pmore}
and

{p 12 15 2}
{cmd:bayesgraph} ...{cmd:,} {it:graphopts}

{pmore}
are equivalent, but you may specify one or the other.

{phang2}
These options are not allowed with {cmd:byparm()} and when only one parameter
is specified.

{phang}
{it:graphopts} specifies options specific to each graph type.

{phang2}
{it:{help bayesgraph##diagopts:diagnosticsopts}} specifies options for use with {cmd:bayesgraph}
{cmd:diagnostics}.  See the corresponding table in the syntax diagram for a
list of options.

{marker tslineopts}{...}
{phang2}
{it:{help tsline##options:tslineopts}} specifies options for use with
{cmd:bayesgraph trace} and {cmd:bayesgraph cusum}.  See the options of 
{helpb tsline} except {cmd:by()}.

{phang2}
{it:acopts} specifies options for use with
{cmd:bayesgraph ac}.

{phang3}
{cmd:ci} requests that the graph of autocorrelations with confidence intervals
be plotted.  By default, confidence intervals are not plotted.  This option is
not allowed with {cmd:byparm()}.

{phang3}
{it:{help corrgram##options_ac:acoptsts}} specifies any options except {cmd:generate()} of the
{cmd:ac} command in {helpb corrgram}.

{marker histopts}{...}
{phang2}
{it:{help histogram##options_continuous:histopts}} specifies options for use
with {cmd:bayesgraph histogram}.  See options of {helpb histogram} except
{cmd:by()}.

{phang2}
{it:kdensityopts} specifies options for use with {cmd:bayesgraph kdensity}.

{phang3}
{it:{help kdensity##options:kdensopts}} specifies options for the overall
kernel density plot.  See the options documented in {helpb kdensity} except
{cmd:generate()} and {cmd:at()}.

{marker showspec}{...}
{phang3}
{opt show(showspec)} specifies which kernel density curves to plot.
{it:showspec} is one of {cmd:both}, {cmd:first}, {cmd:second}, or {cmd:none}.
{cmd:show(both)}, the default, overlays both the first-half density curve and
the second-half density curve with the overall kernel density curve.  If
{cmd:show(first)} is specified, only the first-half density curve, obtained
from the first half of an MCMC sample, is plotted.  If {cmd:show(second)} is
specified, only the second-half density curve, obtained from the second half
of an MCMC sample, is plotted.  If {cmd:show(none)} is specified, only the
overall kernel density curve is shown.

{phang3}
{opt kdensityfirst(kdens1opts)} specifies options of
{helpb graph twoway kdensity} except {cmd:by()} to affect rendition of the
first-half kernel density plot.

{phang3}
{opt kdensitysecond(kdens2opts)} specifies options of 
{helpb graph twoway kdensity} except {cmd:by()} to affect rendition of the
second-half kernel density plot.

{phang2}
{it:{help graph matrix##options:grmatrixopts}} specifies options for use with
{cmd:bayesgraph matrix}.  See the options of {helpb graph matrix} except
{cmd:by()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:bayesgraph} requires specifying at least one parameter with all graph
types, except {cmd:matrix} which requires at least two parameters.  To request
graphs for all parameters, use {cmd:_all}.

{pstd}
By default when multiple graphs are produced, they are automatically stored in
memory with names {cmd:Graph__}{it:#} and will all appear on the screen.
After you are done reviewing the graphs, you can type 
{help graph_drop:{cmd:. graph drop Graph__*}} to close the graphs and drop
them from memory.

{pstd}
If you would like to see only one graph at a time, you can specify either the
{cmd:sleep()} or {cmd:wait} options to include a pause between the subsequent
graphs.  {cmd:close} can be specified to automatically close a graph after the
pause.

{pstd}
You can also combine separate graphs into one by specifying the {cmd:byparm()}
or {cmd:combine()} options.  These options are not allowed with
{cmd:diagnostics} and {cmd:matrix} graphs.

{pstd}
With multiple graphs, you can control the look of each individual graph with
{cmd:graph}{it:#}{cmd:opts()}.  Options common to all graphs may be specified
in {cmd:graphopts()} or passed directly to the command as with single graphs.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse oxygen}{p_end}
{phang2}{cmd:. set seed 14}{p_end}
{phang2}{cmd:. bayesmh change age group, likelihood(normal({c -(}var{c )-}))}
        {cmd:prior({change:}, flat) prior({c -(}var{c )-}, jeffreys)}

{pstd}Diagnostic graphs for all parameters in the model{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}
	
{pstd}Autocorrelation plots for parameters {cmd:{change:age}} and {cmd:{change:_cons}}{p_end}
{phang2}{cmd:. bayesgraph ac {change:age} {change:_cons}}
	
{pstd}Trace plots for parameters {cmd:{c -(}var{c )-}} and {cmd:{change:age}} in a single graph{p_end}
{phang2}{cmd:. bayesgraph trace {c -(}var{c )-} {change:age}, byparm}

{pstd}Histogram of the marginal posterior distribution for parameter
{cmd:{change:age}} with normal distribution overlayed{p_end}
{phang2}{cmd:. bayesgraph histogram {change:age}, normal}
	
{pstd}Kernel density plot for parameter {cmd:{c -(}var{c )-}}{p_end}
{phang2}{cmd:. bayesgraph kdensity {c -(}var{c )-}}
		
{pstd}Cumulative sum plot for parameter {cmd:{change:age}}{p_end}
{phang2}{cmd:. bayesgraph cusum {change:age}}
	
{pstd}Bivariate scatterplot of parameters {cmd:{change:age}} and {cmd:{change:_cons}}{p_end}
{phang2}{cmd:. bayesgraph matrix {change:age} {change:_cons}}{p_end}
