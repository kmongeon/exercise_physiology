{smcl}
{* *! version 3.0.1  05nov2015}{...}
{viewerdialog "putexcel" "dialog putexcel"}{...}
{vieweralsosee "[P] putexcel" "mansection P putexcel"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] putexcel advanced" "help putexcel advanced"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[P] postfile" "help postfile"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _docx*()" "help mf__docx"}{...}
{vieweralsosee "[M-5] xl()" "help mf_xl"}{...}
{viewerjumpto "Syntax" "putexcel##syntax"}{...}
{viewerjumpto "Menu" "putexcel##menu"}{...}
{viewerjumpto "Description" "putexcel##description"}{...}
{viewerjumpto "Options" "putexcel##options"}{...}
{viewerjumpto "Examples" "putexcel##examples"}{...}
{viewerjumpto "Technical note" "putexcel##technote1"}{...}
{viewerjumpto "Appendix" "putexcel##appendix"}{...}
{title:Title}

{p2colset 5 21 23 2}{...}
{p2col :{manlink P putexcel} {hline 2}}Export results to an Excel file{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Set workbook for export

{p 8 32 2}
{cmd:putexcel} {cmd:set} {it:{help filename}}
[{cmd:,} {help putexcel##setopts:{it:set_options}}]


{phang}
Write expression to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {help exp:{it:exp}}
[{cmd:,} {help putexcel##exptopts:{it:export_options}}
{help putexcel##fmtopts:{it:format_options}}]


{phang}
Export Stata matrix to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {opt ma:trix(name)} 
[{cmd:,} {help putexcel##exptopts:{it:export_options}}
{help putexcel##fmtopts:{it:format_options}}]


{phang}
Export Stata graph, path diagram, or other picture to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {opth picture(filename)}


{phang}
Export returned results to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {it:returnset}
[{cmd:,} {help putexcel##exptopts:{it:export_options}}]


{phang}
Write formula to Excel

{p 8 32 2}
{cmd:putexcel} {help putexcel##ulcell:{it:ul_cell}}
    {cmd:=} {opt formula(formula)}
[{cmd:,} {help putexcel##exptopts:{it:export_options}}]


{phang}
Format cells

{p 8 32 2}
{cmd:putexcel} {help putexcel##cellrange:{it:cellrange}}{cmd:,}
{help putexcel##fmtopts:{it:format_options}}


{phang}
Describe current export settings

{p 8 32 2}
{cmd:putexcel} {cmd:describe}


{phang}
Clear current export settings

{p 8 32 2}
{cmd:putexcel} {cmd:clear}


{marker ulcell}{...}
{phang}
{it:ul_cell} is a valid Excel upper-left cell specified using standard
Excel notation, for example, {cmd:A1} or {cmd:D4}.  

{marker cellrange}{...}
{phang}
{it:cellrange} is {it:ul_cell} or {it:ul_cell}{cmd::}{it:lr_cell},
where {it:lr_cell} is a valid Excel lower-right cell, for example, {cmd:A1},
{cmd:A1:D1}, {cmd:A1:A4}, or {cmd:A1:D4}.  


{marker setopts}{...}
{synoptset 42}{...}
{synopthdr:set_options}
{synoptline}
INCLUDE help putexcel_setopts_list.ihlp
{synoptline}

{marker exptopts}{...}
{synoptset 42 tabbed}{...}
{synopthdr:export_options}
{synoptline}
{syntab:Main}
INCLUDE help putexcel_exptopts_list.ihlp
{synoptline}

{marker fmtopts}{...}
{synoptset 42 tabbed}{...}
{synopthdr:format_options}
{synoptline}
{syntab:Number}
INCLUDE help putexcel_numopt_list.ihlp

{syntab:Alignment}
INCLUDE help putexcel_alignopts_list.ihlp

{syntab:Font}
INCLUDE help putexcel_textopts_list.ihlp

{syntab:Border}
INCLUDE help putexcel_bordopts_list.ihlp

{syntab:Fill}
INCLUDE help putexcel_fillopt_list.ihlp
{synoptline}


{title:Output types}

INCLUDE help putexcel_output_types.ihlp


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Export > Results to Excel spreadsheet (*.xls;*.xlsx)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:putexcel} writes Stata {help expressions:expressions},
{help matrix:matrices}, images, and {help return:returned results} to an Excel
file.  It may also be used to format cells in an Excel worksheet.  This allows
you to automate exporting and formatting of, for example, Stata estimation
results.  Excel 1997/2003 ({cmd:.xls}) files and Excel 2007/2010 and newer
({cmd:.xlsx}) files are supported.  

{pstd}
{cmd:putexcel} {cmd:set} sets the Excel file to create, modify, or replace in
subsequent {cmd:putexcel} commands.  You must set the destination file before
using any other {cmd:putexcel} commands.  {cmd:putexcel clear} clears the file
information set by {cmd:putexcel set}.  {cmd:putexcel describe} displays the
file information set by {cmd:putexcel set}.

{pstd}
For the advanced syntax that lets you simultaneously write multiple output
types, see {manhelp putexcel_advanced P:putexcel advanced}.


{marker options}{...}
{title:Options}

{dlgtab:Set}

INCLUDE help putexcel_set_opts.ihlp

{dlgtab:Main}

INCLUDE help putexcel_expt_opts.ihlp

{dlgtab:Number}

INCLUDE help putexcel_num_opt.ihlp

{dlgtab:Alignment}

INCLUDE help putexcel_align_opts.ihlp

{dlgtab:Font}

INCLUDE help putexcel_text_opts.ihlp

{dlgtab:Border}

INCLUDE help putexcel_bord_opts.ihlp

{dlgtab:Fill}

INCLUDE help putexcel_fill_opt.ihlp


{marker examples}{...}
{title:Examples}

{pstd}
Declare first sheet of results.xlsx as the destination for subsequent
{cmd:putexcel} commands{p_end}
{phang2}{cmd:. putexcel set results}

{pstd}
Write the text "Variable", "Mean", and "Std. Dev." to cells A1, B1, and
C1{p_end}
{phang2}{cmd:. putexcel A1 = "Variable"}{p_end}
{phang2}{cmd:. putexcel B1 = "Mean"}{p_end}
{phang2}{cmd:. putexcel C1 = "Std. Dev."}

{pstd}
Summarize the {cmd:mpg} variable{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. summarize mpg}

{pstd}
Obtain the names of the returned results for the mean and the
standard deviation, {cmd:r(mean)} and {cmd:r(sd)}{p_end}
{phang2}{cmd:. return list}

{pstd}
Write the variable name, mean, and standard deviation in cells A2, B2, and C2;
specify a format with two decimal places for the mean and standard
deviation{p_end}
{phang2}{cmd:. putexcel A2 = "mpg"}{p_end}
{phang2}{cmd: 	. putexcel B2 = `r(mean)', nformat(number_d2)}{p_end}
{phang2}{cmd:	. putexcel C2 = `r(sd)', nformat(number_d2)}{p_end}

{pstd}
Fit a regression of {cmd:mpg} on weight and displacement{p_end}
{phang2}{cmd:. regress mpg weight displacement}

{pstd}
Write the text "Coef."  to cell B5{p_end}
{phang2}{cmd:. putexcel B5 = "Coef."}

{pstd}
Write the matrix of coefficients and their labels contained in the matrix row
names from the transposed {cmd:e(b)} matrix; specify that this matrix is
written with the upper left entry in cell A6{p_end}
{phang2}{cmd:. matrix b = e(b)'}{p_end}
{phang2}{cmd:. putexcel A6 = matrix(b), rownames}


{marker technote1}{...}
{title:Technical note:  Excel data size limits and dates and times}

{pstd}
You can read about Excel data size limits and the two different Excel date
systems in {helpb import_excel##technote1:help import excel}.
{p_end}


{marker appendix}{...}
{title:Appendix}

{marker nformat}{...}
    {title:Codes for numeric formats}

	 Code                           Example
	{hline 40}
	 {cmd:number}                            1000
	 {cmd:number_d2}                      1000.00
	 {cmd:number_sep}                     100,000
	 {cmd:number_sep_d2}               100,000.00
	 {cmd:number_sep_negbra}              (1,000)
	 {cmd:number_sep_negbrared}           {error}(1,000){txt}
	 {cmd:number_d2_sep_negbra}        (1,000.00)
	 {cmd:number_d2_sep_negbrared}     {error}(1,000.00){txt}
	 {cmd:currency_negbra}                ($4000)
	 {cmd:currency_negbrared}             {error}($4000){txt}
	 {cmd:currency_d2_negbra}          ($4000.00)
	 {cmd:currency_d2_negbrared}       {error}($4000.00){txt}
	 {cmd:account}                          5,000
	 {cmd:accountcur}      	           $    5,000
	 {cmd:account_d2}                    5,000.00
	 {cmd:account_d2_cur}              $ 5,000.00
	 {cmd:percent}                            75%
	 {cmd:percent_d2}                      75.00%
	 {cmd:scientific_d2}                 10.00E+1
	 {cmd:fraction_onedig}                 10 1/2
	 {cmd:fraction_twodig}               10 23/95
	 {cmd:date}                         3/18/2007
	 {cmd:date_d_mon_yy}                18-Mar-07
	 {cmd:date_d_mon}                      18-Mar
	 {cmd:date_mon_yy}                     Mar-07
	 {cmd:time_hmm_AM}                    8:30 AM
	 {cmd:time_HMMSS_AM}               8:30:00 AM
	 {cmd:time_HMM}                          8:30
	 {cmd:time_HMMSS}                     8:30:00
	 {cmd:time_MMSS}                        30:55
	 {cmd:time_H0MMSS}                   20:30:55
	 {cmd:time_MMSS0}                     30:55.0
	 {cmd:date_time}               3/18/2007 8:30
	 {cmd:text}                      this is text
	{hline 40}


{marker Colors}{...}
    {title:Colors}

         {it:color}
        {hline 52}
	 {cmd}aliceblue       ghostwhite            navajowhite
	 antiquewhite    gold                  navy
	 aqua            goldenrod             oldlace
	 aquamarine      gray                  olive
	 azure           green                 olivedrab
	 beige           greenyellow           orange
	 bisque          honeydew              orangered
	 black           hotpink               orchid
	 blanchedalmond  indianred             palegoldenrod
	 blue            indigo                palegreen
	 blueviolet      ivory                 paleturquoise
	 brown           khaki                 palevioletred
	 burlywood       lavender              papayawhip
	 cadetblue       lavenderblush         peachpuff
	 chartreuse      lawngreen             peru
	 chocolate       lemonchiffon          pink
	 coral           lightblue             plum
	 cornflowerblue  lightcoral            powderblue
	 cornsilk        lightcyan             purple
	 crimson         lightgoldenrodyellow  red
	 cyan            lightgray             rosybrown
	 darkblue        lightgreen            royalblue
	 darkcyan        lightpink             saddlebrown
	 darkgoldenrod   lightsalmon           salmon
	 darkgray        lightseagreen         sandybrown
	 darkgreen       lightskyblue          seagreen
	 darkkhaki       lightslategray        seashell
	 darkmagenta     lightsteelblue        sienna
	 darkolivegreen  lightyellow           silver
	 darkorange      lime                  skyblue
	 darkorchid      limegreen             slateblue
	 darkred         linen                 slategray
	 darksalmon      magenta               snow
	 darkseagreen    maroon                springgreen
	 darkslateblue   mediumaquamarine      steelblue
	 darkslategray   mediumblue            tan
	 darkturquoise   mediumorchid          teal
	 darkviolet      mediumpurple          thistle
	 deeppink        mediumseagreen        tomato
	 deepskyblue     mediumslateblue       turquoise
	 dimgray         mediumspringgreen     violet
	 dodgerblue      mediumturquoise       wheat
	 firebrick       mediumvioletred       white
	 floralwhite     midnightblue          whitesmoke
	 forestgreen     mintcream             yellow
	 fuchsia         mistyrose             yellowgreen
	 gainsboro       moccasin{txt}
        {hline 52}


{marker style}{...}
    {title:Border styles}

         {it:style}
	{hline 25}
	 {cmd:none}
	 {cmd:thin}
	 {cmd:medium}
	 {cmd:dashed}
	 {cmd:dotted}
	 {cmd:thick}
	 {cmd:double}
	 {cmd:hair}
	 {cmd:medium_dashed}
	 {cmd:dash_dot}
	 {cmd:medium_dash_dot}
	 {cmd:dash_dot_dot}
	 {cmd:medium_dash_dot_dot}
	 {cmd:slant_dash_dot}
	{hline 25}


{marker pattern}{...}
    {title:Background patterns}

         {it:pattern} 
	{hline 25}
	 {cmd:none}
	 {cmd:solid}
	 {cmd:gray50}
	 {cmd:gray75}
	 {cmd:gray25}
	 {cmd:horstripe}
	 {cmd:verstripe}
	 {cmd:diagstripe}
	 {cmd:revdiagstripe}
	 {cmd:diagcrosshatch}
	 {cmd:thinhorstripe}
	 {cmd:thinverstripe}
	 {cmd:thindiagstripe}
	 {cmd:thinrevdiagstripe}
	 {cmd:thinhorcrosshatch}
	 {cmd:thindiagcrosshatch}
	 {cmd:thickdiagcrosshatch}
	 {cmd:gray12p5}
	 {cmd:gray6p25}
        {hline 25}
