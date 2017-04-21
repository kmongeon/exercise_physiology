{* *! version 1.0.0  22oct2015}{...}
{* *! This ihlp is for putexcel. If you make changes here, check}{...}
{* *! if similar changes need be made to putexcela_output_types.ihlp.}{...}
{marker expr}{...}
{phang}
{it:exp} writes a valid Stata expression to a cell.  See
{helpb exp:[U] 13 Functions and expressions}.  Stata dates and datetimes
differ from Excel dates and datetimes.  To properly export date and datetime
values, use {opt asdate} and {opt asdatetime}.

{marker matrix}{...}
{phang}
{opth matrix:(matrix:name)} writes the values from a Stata matrix to Excel.
Stata determines where to place the data in Excel by default from the size of
the matrix (the number of rows and columns) and the location you specified in
{it:ul_cell}.  By default, {it:ul_cell} contains the first element of
{it:name}, and matrix row names and column names are not written.

{marker picture}{...}
{phang}
{opth picture(filename)} writes a portable network graphics ({cmd:.png}), JPEG
({cmd:.jpg}), Windows metafile ({cmd:.wmf}), device-independent bitmap
({cmd:.dib}), enhanced metafile ({cmd:.emf}), or bitmap ({cmd:.bmp}) file to
an Excel worksheet.  The upper-left corner of the image is aligned with the
upper-left corner of the specified {it:ul_cell}.  The image is not resized.
If {it:filename} contains spaces, it must be enclosed in double quotes.

{marker returnset}{...}
{phang}
{it:returnset} is a shortcut name that is used to identify a group of
{help return} values.  It is intended primarily for use by programmers and by
those who intend to do further processing of their exported results in Excel.
{it:returnset} may be any one of the following:

         {it:returnset}
	{hline 25}
         {opt escal:ars}   {opt escalarn:ames}
         {opt rscal:ars}   {opt rscalarn:ames}
         {opt emac:ros}    {opt emacron:ames}
         {opt rmac:ros}    {opt rmacron:ames}
         {opt emat:rices}  {opt ematrixn:ames}
         {opt rmat:rices}  {opt rmatrixn:ames}
         {opt e*}          {opt ena:mes}
         {opt r*}          {opt rna:mes}
	{hline 25}

{marker formula}{...}
{phang}
{opt formula(formula)} writes an Excel formula to the cell specified in
{it:ul_cell}.  {it:formula} may be any valid Excel formula.  Stata does not
validate formulas; the text is passed literally to Excel.
{p_end}
