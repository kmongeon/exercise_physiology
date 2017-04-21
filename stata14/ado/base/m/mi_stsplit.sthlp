{smcl}
{* *! version 1.0.10  10dec2014}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi stsplit" "mansection MI mistsplit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stsplit" "help stsplit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi xxxset" "help mi_xxxset"}{...}
{viewerjumpto "Syntax" "mi_stsplit##syntax"}{...}
{viewerjumpto "Menu" "mi_stsplit##menu"}{...}
{viewerjumpto "Description" "mi_stsplit##description"}{...}
{viewerjumpto "Options" "mi_stsplit##options"}{...}
{viewerjumpto "Remarks" "mi_stsplit##remarks"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{manlink MI mi stsplit} {hline 2}}Stsplit and stjoin mi data{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
To split at designated times

{p 8 16 2}
{cmd:mi} {cmd:stsplit} {newvar} [{it:{help if}}]{cmd:,}
{c -(}{cmd:at(}{it:{help numlist}}{cmd:)} | {opt ev:ery(#)}{c )-}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {cmd:at(}{it:{help numlist}}{cmd:)}}split at specified analysis
            times{p_end}
{p2coldent :* {cmdab:ev:ery(}{it:#}{cmd:)}}split when analysis time is a
            multiple of {it:#}{p_end}
{synopt :{cmdab:af:ter(}{it:spec}{cmd:)}}use time since {it:spec} instead of
analysis time for {cmd:at()} or {cmd:every()}{p_end}
{synopt :{cmd:trim}}exclude observations outside of range{p_end}
{synopt :{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}

{synopt : {cmdab:nopre:serve}}programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:at()} or {cmd:every()} is required.{p_end}
{p 4 6 2}
{cmd:nopreserve} is not included in the dialog box.



{phang}
To split at failure times

{p 8 16 2}
{cmd:mi} {cmd:stsplit} [{it:{help if}}]{cmd:,} {cmd:at(}{opt f:ailures)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {cmd:at(failures)}}split at times of observed failures{p_end}
{synopt :{cmdab:st:rata(}{varlist}{cmd:)}}perform splitting by failures within
         stratum, strata defined by {it:varlist}{p_end}
{synopt :{cmdab:r:iskset(}{newvar}{cmd:)}}create risk-set ID variable{p_end}
{synopt :{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}

{synopt :{cmdab:nopre:serve}}programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {cmd:at()} is required.{p_end}
{p 4 6 2}{cmd:nopreserve} is not included in the dialog box.


{phang}
To join episodes

{p 8 15 2}
{cmd:mi} {cmd:stjoin} [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmdab:c:ensored(}{it:{help numlist}}{cmd:)}}values of failure that
         indicate no event{p_end}
{synopt :{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:stsplit} and {cmd:mi} {cmd:stjoin} are 
{cmd:stsplit} and {cmd:stjoin} for {cmd:mi} data;
see {bf:{help stsplit:[ST] stsplit}}.
Except for the addition of the {cmd:noupdate} option, 
the syntax is identical.  Except for generalization across {it:m}, the 
results are identical.

{p 4 4 2}
Your {cmd:mi} data must be {cmd:stset} to use these commands.  If your 
data are not already {cmd:stset}, use 
{cmd:mi} {cmd:stset}
rather than the standard {cmd:stset};
see {bf:{help mi_xxxset:[MI] mi XXXset}}.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.

{p 4 4 2}
See {bf:{help stsplit:[ST] stsplit}} for documentation on the remaining options.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
One should never use any heavyweight data-management commands 
with {cmd:mi} data.  Heavyweight commands are commands that make sweeping
changes to the data rather than simply deleting some observations, adding or
dropping some variables, or changing some values of existing variables.
{cmd:stsplit} and {cmd:stjoin} are examples of heavyweight commands
(see {manhelp stsplit ST}.
{p_end}
