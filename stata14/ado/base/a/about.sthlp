{smcl}
{* *! version 1.4.8  02jan2017}{...}
{viewerdialog about "dialog about_dlg"}{...}
{vieweralsosee "[R] about" "mansection R about"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 3 Resources for learning and using Stata" "help stata"}{...}
{vieweralsosee "stata/ic" "help stataic"}{...}
{vieweralsosee "stata/se" "help statase"}{...}
{vieweralsosee "stata/mp" "help statamp"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "about##syntax"}{...}
{viewerjumpto "Menu" "about##menu"}{...}
{viewerjumpto "Description" "about##description"}{...}
{viewerjumpto "Remarks" "about##remarks"}{...}
{title:Title}

{p 4 19 2}
{manlink R about} {hline 2} Display information about your Stata


{marker syntax}{...}
{title:Syntax}

    {cmd:about}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Help > About Stata}


{marker description}{...}
{title:Description}

{pstd}
{cmd:about} displays information about your version of Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
If you are running Stata for Windows, information about memory is also
displayed:

         {cmd:. about}

         {res}Stata/MP 14.2 for Windows (64-bit x86-64)
	 Revision 20 Aug 2016
	 Copyright 1985-2015 StataCorp LLC

	 Total physical memory:     8388608 KB
	 Available physical memory:  937932 KB

	 10-user 32-core Stata network perpetual license:
	        Serial number:  5013041234
	          Licensed to:  Alan R. Riley
	                        StataCorp{txt}
