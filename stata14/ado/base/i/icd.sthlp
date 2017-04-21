{smcl}
{* *! version 1.0.3  06sep2016}{...}
{vieweralsosee "[D] icd" "mansection D icd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] icd9" "help icd9"}{...}
{vieweralsosee "[D] icd10" "help icd10"}{...}
{viewerjumpto "Description" "icd##description"}{...}
{viewerjumpto "Remarks" "icd##remarks"}{...}
{viewerjumpto "References" "icd##references"}{...}
{title:Title}

{p2colset 5 16 18 2}{...}
{p2col :{manlink D icd} {hline 2}}Introduction to ICD commands{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry provides a brief introduction to the basic concepts of the
International Classification of Diseases (ICD).  If you are not familiar
with ICD terminology, we recommend that you read this entry before
proceeding to the individual command entries.  

{pstd}
This entry also provides an overview of the format of the codes from each
coding system that Stata's {cmd:icd} commands support.  Stata supports ninth
revision codes (ICD-9) and tenth revision codes (ICD-10). For ICD-9,
Stata uses codes from the United States's Clinical Modification, the
ICD-9-CM.  For ICD-10, Stata uses the World Health Organization's (WHO's)
codes for international morbidity and mortality reporting.  We encourage you
to read this entry to ensure that you choose the correct command and that your
data are in the proper format for using the {cmd:icd} suite of commands.

{pstd}
Finally, this entry provides information about using the {cmd:icd} commands
with multiple diagnosis or procedure codes at one time. None of the commands
accepts a varlist, so we illustrate methods for working with multiple codes.

{pstd}
If you are familiar with ICD coding and the {cmd:icd} commands in Stata,
you may want to skip to the command-specific entries for details about syntax
and examples.

                {bf:Commands for ICD-9 codes}
             {helpb icd9}   ICD-9-CM diagnostic codes
             {helpb icd9p}  ICD-9-CM procedure codes

                {bf:Commands for ICD-10 codes}
             {helpb icd10}  ICD-10 diagnosis codes


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help icd##intro:Introduction to ICD coding}
        {help icd##terminology:Terminology}
        {help icd##diagcodes:Diagnosis codes}
        {help icd##prcodes:Procedure codes}


{marker intro}{...}
{title:Introduction to ICD coding}

{pstd}
The {cmd:icd} commands in Stata are implemented for two specific 
coding systems: ICD-9-CM and ICD-10.  

{pstd}
The International Classification of Diseases (ICD) coding system was
developed by and is copyrighted by the World Health Organization (WHO).
The ICD coding system is used for standardized mortality reporting and, by
many countries, for reporting of morbidity and coding of diagnoses during
health care encounters. Since 1999, the ICD system has been under its tenth
revision, ICD-10 ({help icd##who2011:World Health Organization 2011}). These
codes provide information only about diagnoses, not about procedures.

{pstd}
The United States and some other countries have also developed
country-specific coding systems that are extensions of WHO's system.  These
systems are used for coding information about health care encounters. In the
United States, the coding system is referred to as the International
Classification of Diseases, Clinical Modification.  These codes are maintained
and distributed by the National Center for Health Statistics (NCHS) at the
U.S. Centers for Disease Control and Prevention (CDC) and by the Centers for
Medicare and Medicaid Services (CMS).


{marker terminology}{...}
{title:Terminology}

{pstd}
The {cmd:icd9} and {cmd:icd10} entries assume knowledge of common terminology
used in the ICD-9-CM documentation from the NCHS or CMS or in
the ICD-10 revision manuals from WHO.  The following brief definitions are
provided as a reference.

{phang}
{bf:edition.} The ICD-9-CM and ICD-10 each have editions, which
represent major periodic changes.  ICD-9-CM is currently in its sixth edition
({help icd##nchs2011:National Center for Health Statistics 2011}).
ICD-10 is currently in its fifth edition
({help icd##who2011:World Health Organization 2011}).

{phang}
{bf:version.} In the ICD-9-CM coding system, a new version is published each
year and is issued with a sequential version number.  The current version
is 32.

{phang}
{bf:update.} In the ICD-10 coding system, an update may occur each year.
The update is not issued with a number but may be identified by the year in
which it occurred.

{phang}
{bf:category code.} A category code is the portion of the ICD code
that precedes the period.  It may represent a single disease or a group of
related diseases or conditions. 

{phang}
{bf:valid code.} A valid code is one that may be used for reporting in the
current version of the ICD-9-CM or current update to the ICD-10 edition.
What constitutes a valid code changes over time. 

{phang}
{bf:defined code.} A defined code is any code that either is currently valid,
was valid at a previous time, or has meaning as a grouping of codes.  See
{manhelp icd9 D} and {manhelp icd10 D} for information about how the
individual commands treat defined codes.


{marker diagcodes}{...}
{title:Diagnosis codes}

{pstd}
Let's begin with the diagnostic codes processed by {cmd:icd9}.
An ICD-9-CM diagnosis code may have one of two formats. Most use the format

{phang2}
{{cmd:0}-{cmd:9},{cmd:V}}{{cmd:0}-{cmd:9}}{{cmd:0}-{cmd:9}}[{cmd:.}][{cmd:0}-{cmd:9}[{cmd:0}-{cmd:9}]]

{pstd}
while E-codes have the format

{phang2}
{cmd:E}{{cmd:0}-{cmd:9}}{{cmd:0}-{cmd:9}}{{cmd:0}-{cmd:9}}[{cmd:.}][{cmd:0}-{cmd:9}]

{pstd}
where braces, {}, indicate required items and brackets,
[], indicate optional items.  

{pstd}
ICD-9-CM codes begin with a  digit from {cmd:0} to {cmd:9}, the letter {cmd:V},
or the letter {cmd:E}.  E-codes are always followed by three digits and may have
another digit in the fifth place. All other codes are followed by two digits and
may have up to two more digits.  

{pstd}
The format of an ICD-10 diagnosis code is

{phang2}
{{cmd:A}-{cmd:T},{cmd:V}-{cmd:Z}}{{cmd:0}-{cmd:9}}{{cmd:0}-{cmd:9}}[{cmd:.}][{cmd:0}-{cmd:9}]

{pstd}
Each ICD-10 code begins with a single letter followed by two digits.  It may
have an additional third digit after the period.  

{pstd}
Diagnosis codes must be stored in a string variable (see
{manhelp data_types D:data types}).  For codes from either revision, the period
separating the category code from the other digits is treated as implied if it
is not present. 

    {title:Technical note}

{pstd}
There are defined five- and six-character ICD-10 codes. However, 
these codes are not part of the standard four-character system codified
by WHO for international morbidity and mortality reporting and are not
considered valid by {cmd:icd10}.  See {manhelp icd10 D} for additional details about
these codes and options for using {cmd:icd10} with them.


    {title:Technical note}

{pstd}
ICD-10 codes U00-U49 are reserved for use by WHO for provisional
assignment of new diseases.  Codes U50-U99 may be used for research
purposes to identify subjects with specific conditions under study for which
there is no defined ICD-10 code
({help icd##who2011:World Health Organization 2011}).

{pstd}
If you are working in one of these specialized cases, see the 
{mansection D icd10Remarksandexamplesucodes:technical note}}
in {bf:[D] icd10}.


{marker prcodes}{...}
{title:Procedure codes}

{pstd}
The ICD-9-CM coding system also includes procedure codes. The format of
ICD-9-CM procedure codes is

{phang2}
{{cmd:0}-{cmd:9}}{{cmd:0}-{cmd:9}}[{cmd:.}][{cmd:0}-{cmd:9}[{cmd:0}-{cmd:9}]]

{pstd}
Procedure codes must be stored in a string variable. 
{p_end}


{marker references}{...}
{title:References}

{marker nchs2011}{...}
{phang}
National Center for Health Statistics. 2011. International
Classification of Diseases, Ninth Revision, Clinical Modification.
{browse "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Publications/ICD9-CM/2011/"}.

{marker who2011}{...}
{phang}
World Health Organization. 2011. International Statistical Classification of
Diseases and Related Health Problems, Vol. 2:
2016 Edition. Instruction manual.
{browse "http://apps.who.int/classifications/icd10/browse/Content/statichtml/ICD10Volume2_en_2016.pdf"}.
{p_end}