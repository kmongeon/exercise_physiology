{* *! version 1.0.1  17dec2015}{...}
{* *! This help file is called by both putexcel & putexcel advanced.}{...}
{phang}
{cmd:sheet(}{it:sheetname} [{cmd:, replace}]{cmd:)} saves to the worksheet
named {it:sheetname}.  If there is no worksheet named {it:sheetname} in the
workbook, then a new sheet named {it:sheetname} is created.  If this option is
not specified, the first worksheet of the workbook is used.

{pmore}
{opt replace} permits {opt putexcel set} to overwrite {it:sheetname} if it
exists in the specified {it:filename}.

{phang} 
{opt modify} permits {opt putexcel set} to modify an Excel file.

{phang} 
{opt replace} permits {opt putexcel set} to overwrite an existing Excel
workbook.  The workbook is overwritten when the first {cmd:putexcel} command
is issued.
{p_end}
