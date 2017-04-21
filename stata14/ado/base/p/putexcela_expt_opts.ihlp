{* *! version 1.0.1  30nov2015}{...}
{* *! This ihlp is for putexcel advanced. If you make changes here, check}{...}
{* *! if similar changes need be made to putexcel_expt_opts.ihlp.}{...}
{phang}
{opt overwritefmt} causes {opt putexcel} to remove any existing cell
formatting in the cell or cells to which it is writing new output.  By
default, all existing cell formatting is preserved.

{phang}
{opt asdate} tells {opt putexcel} that the specified {it:exp} is a Stata
{cmd:%td}-formatted date that should be converted to an Excel date
with {it:m}/{it:d}/{it:yyyy} Excel date format.

{pmore}
This option has no effect if an {help exp:{it:exp}} is not specified as 
one of the output types.

{phang}
{opt asdatetime} tells {opt putexcel} that the specified {it:exp} is a Stata
{cmd:%tc}-formatted datetime that should be converted to an Excel datetime
with {it:m}/{it:d}/{it:yyyy h}:{it:mm} Excel datetime format.

{pmore}
This option has no effect if an {help exp:{it:exp}} is not specified as 
one of the output types.

{phang}
{opt asdatenum} tells {opt putexcel} that the specified {it:exp} is a Stata
{cmd:%td}-formatted date that should be converted to an Excel date number,
preserving the cell's format.

{pmore}
This option has no effect if an {help exp:{it:exp}} is not specified as 
one of the output types.

{phang}
{opt asdatetimenum} tells {opt putexcel} that the specified {it:exp} is a Stata
{cmd:%tc}-formatted datetime that should be converted to an Excel datetime
number, preserving the cell's format.

{pmore}
This option has no effect if an {help exp:{it:exp}} is not specified as 
one of the output types.

{phang}
{opt names} specifies that matrix row names and column names be written into
the Excel worksheet along with the matrix values.  If you specify {opt names},
then {it:ul_cell} will be blank, the cell to the right of it will contain the
name of the first column, and the cell below it will contain the name of the
first row.  {opt names} may not be specified with {opt rownames} or
{opt colnames}.

{pmore}
This option has no effect if {opt matrix()} is not specified as 
one of the output types.

{phang}
{opt rownames} specifies that matrix row names be written into the Excel
worksheet along with the matrix values.  If you specify {opt rownames}, then
{it:ul_cell} will contain the name of the first row.  {opt rownames} may not
be specified with {opt names} or {opt colnames}.

{pmore}
This option has no effect if {opt matrix()} is not specified as 
one of the output types.

{phang}
{opt colnames} specifies that matrix column names be written into the
Excel worksheet along with the matrix values.  If you specify {opt colnames},
then {it:ul_cell} will contain the name of the first column.  {opt colnames}
may not be specified with {opt names} or {opt rownames}.

{pmore}
This option has no effect if {opt matrix()} is not specified as 
one of the output types.

{phang}
{opt colwise} specifies that if a {help putexcel##returnset:{it:returnset}} is
used, the values written to the Excel worksheet be written in consecutive
columns.  By default, the values are written in consecutive rows.

{pmore}
This option has no effect if a {it:returnset} is not specified as 
one of the output types.
{p_end}