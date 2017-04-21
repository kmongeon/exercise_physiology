{smcl}
{* *! version 1.0.2  20mar2015}{...}
{vieweralsosee "[P] set locale_ui" "mansection P setlocale_ui"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_locale_ui##syntax"}{...}
{viewerjumpto "Description" "set_locale_ui##description"}{...}
{title:Title}

{p2colset 5 26 28 2}{...}
{p2col:{manlink P set locale_ui} {hline 2}}Specify a localization package for the user interface
{p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Use the system locale for user interface localization 

{p 8 16 2}
{cmd:set}
{cmd:locale_ui}
{cmd:default}


{pstd}
Specify a locale for user interface localization

{p 8 16 2}
{cmd:set}
{cmd:locale_ui}
{it:locale}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:locale_ui} sets the locale that Stata uses for the user
interface (UI).  If a localization package can be matched to the specified
{it:locale}, the language contained in that package will be used to
display various UI elements (menus, dialogs, message boxes, etc.).  The
setting takes effect the next time Stata starts.

{pstd}
The default language for Stata's UI elements is English.  Currently,
additional localization packages exist for Japanese and Spanish.

{pstd}
For example, the command {cmd:set locale_ui ja}, where {cmd:ja} is the
language code for Japanese, causes Stata to display menus and various other UI
text in Japanese.  If a localization package for Japanese cannot be found,
then the UI text will continue to be displayed using the English defaults.

{pstd}
For further discussion of locales, see {findalias frlocales}.

{pstd}
The current UI setting is stored in {cmd:c(locale_ui)}.
{p_end}
