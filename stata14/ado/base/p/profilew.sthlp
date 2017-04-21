{smcl}
{* *! version 1.2.2  18jul2014}{...}
{findalias asgswprofile}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] do" "help do"}{...}
{vieweralsosee "[R] doedit" "help doedit"}{...}
{viewerjumpto "Description" "profilew##description"}{...}
{viewerjumpto "Examples" "profilew##examples"}{...}
{title:Title}

{p 4 16 2}
{findalias gswprofile} 


{marker description}{...}
{title:Description}

{pstd}
Stata first looks for the file sysprofile.do when it is invoked.  After that,
Stata looks for the file profile.do.  If either of these files are found, Stata
executes the commands they contain.  Stata looks (1) in the directory where
Stata was installed, (2) in the current directory, (3) along your PATH, (4) in
your home directory as defined by Windows's USERPROFILE environment variable,
and finally (5) along the adopath (see {helpb adopath}).

{pstd}
sysprofile.do is intended for system administrators.  We recommend that it be
placed in the directory where Stata is installed.  We recommend that you put
profile.do in the default working directory which you set when you installed
Stata.  If you are not sure what your working directory is, type {cmd:pwd} in
the Command window immediately after starting Stata.


{marker examples}{...}
{title:Examples}

{pstd}
Say that every time you started Stata you wanted {cmd:niceness} set to 6
(see {helpb memory}).

{p 8 12 2}Create file C:\Users\mydir\Documents\profile.do containing

{p 8 12 2}{cmd:set niceness 6}

{p 8 12 2}When you invoke Stata, this command will be executed:

{p 8 12 2}{res:running C:\Users\mydir\Documents\profile.do ...}{p_end}
	{cmd:. _ }

{pstd}
If a system administrator wanted to change the path to Stata's SITE directory,
then {cmd:sysprofile.do} could be created and contain the command

{p 8 12 2}{cmd:sysdir set SITE \\Matador\StataFiles}

{p 8 12 2}When you invoke Stata, this command will be executed:

{p 8 12 2}{res:running C:\Stata\sysprofile.do ...}{p_end}
	{cmd:. _ }

{p 8 12 2}If profile.do exists, Stata would run that after sysprofile.do
finished.

{pstd}
sysprofile.do and profile.do are treated just as any other do-files once they
are executed; results are literally as if you started Stata and then typed
{cmd:run sysprofile.do} or {cmd:run profile.do}.  The only special thing about
these do-files is that Stata looks for them and runs them automatically.  If
sysprofile.do or profile.do do not already exist, then you will have to create
them.  This can be done just as you would create any other do-file.

{pstd}
See {findalias frdofiles} for an explanation of do-files.  They are nothing
more than text (ASCII) files containing a sequence of commands for Stata to
execute.
{p_end}