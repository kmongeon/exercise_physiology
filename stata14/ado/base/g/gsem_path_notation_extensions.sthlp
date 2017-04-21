{smcl}
{* *! version 1.0.1  31may2013}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] gsem path notation extensions" "mansection SEM gsempathnotationextensions"}{...}
{vieweralsosee "[SEM] intro 2" "mansection SEM intro2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation"}{...}
{viewerjumpto "Description" "gsem_path_notation_extensions##description"}{...}
{viewerjumpto "Options" "gsem_path_notation_extensions##options"}{...}
{viewerjumpto "Remarks" "gsem_path_notation_extensions##remarks"}{...}
{viewerjumpto "Examples" "gsem_path_notation_extensions##examples"}{...}
{title:Title}

{p2colset 5 44 46 2}{...}
{p2col:{manlink SEM gsem path notation extensions} {hline 2}}Command syntax for
path diagrams{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {it:paths} ... [{cmd:,} {opt covariance()} {opt variance()} 
            {opt means()}]

{pstd}
{it:paths} specifies the direct paths between the variables of your model.

{pstd}
The model to be fit is fully described by {it:paths}, 
{opt covariance()}, {opt variance()}, and {opt means()}.


{marker description}{...}
{title:Description}

{pstd}
This entry concerns {cmd:gsem} only.

{pstd}
The command syntax for describing generalized SEMs is fully
specified by {it:paths}, {opt covariance()}, {opt variance()}, and 
{opt means()};
{helpb sem and gsem path notation:[SEM] sem and gsem path notation}.

{pstd}
With {cmd:gsem}, the notation is extended to allow for generalized linear
response variables and to allow for multilevel latent variables.  That is the
subject of this entry.


{marker options}{...}
{title:Options}

{phang}
{opt covariance()},
{opt variance()}, and
{opt means()} are described in
{helpb sem and gsem path notation:[SEM] sem and gsem path notation}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

            {help gsem path notation extensions##gsem_ext1:Specifying multilevel nested latent variables}
            {help gsem path notation extensions##gsem_ext2:Specifying multilevel crossed latent variables}
            {help gsem path notation extensions##gsem_ext3:Specifying family and link}


{marker gsem_ext1}{...}
{title:Specifying multilevel nested latent variables}

{pstd}
Latent variables are indicated by a name in which at least the first letter is
capitalized.  This generic form of the name is often written {it:Lname}. 

{pstd}
In regular latent variables, which we will call level-1 latent variables, the
unobserved values vary observation by observation.  Level-1 latent variables
are the more common kinds of latent variables. 

{pstd}
{cmd:gsem} allows higher-level latent variables as well as the level-1
variables.  Let's consider three-level data:  students at the observational
level, teachers at the second level, and schools at the third.  In these data,
each observation is a student.  We have data on students nested within teacher
nested within school.

{pstd}
Let's assume that we correspondingly have three identification
(ID) variables.  We number the following list with the nesting level
of the data:

{phang}
3.  Variable {cmd:school} contains a school ID number. 
           If two observations have the same value of {cmd:school}, then both 
           of those students attended the same school. 

{phang}
2.  Variable {cmd:teacher} contains a teacher ID number,
           or it contains a teacher-within-school ID number. 
	   That is, we do not care whether different schools assigned 
	   teachers the same ID number.  It will be sufficient for us
	   that the ID number is unique within school.  

{phang}
1.  Variable {cmd:student} contains a student ID number, 
           or it contains a student-within-school ID number, 
           or even a student-within-teacher-within-school ID 
           number.  That is, we do not care whether different observations 
	   have the same student ID as long as they have different
	   teacher IDs or different school IDs. 

{pstd}
Here is how you write latent-variable names at each level of the
model:

{phang}
3.  Level 3 is the school level.  Latent variables are written as 

{pmore}
     {it:Lname}{cmd:[school]}  

{pmore}
	An example would be {cmd:SchQuality[school]}. 

{pmore}
           The unobserved values of {it:Lname}{cmd:[school]} vary across
           schools and are constant within school.

{pmore}
           If {it:Lname}{cmd:[school]} is endogenous, its error variable is 
	   {cmd:e.}{it:Lname}{cmd:[school]}. 

{pmore}
           You must refer to 
           {it:Lname}{cmd:[school]} without omitting the {cmd:[school]} part. 
           {it:Lname} by itself looks like another latent variable 
           to {cmd:gsem}. 

{phang}     
2.  Level 2 is the teacher-within-school level.  Latent variables are 
           written as 

{phang3}
           {it:Lname}{cmd:[school>teacher]} or{break}
           {it:Lname}{cmd:[teacher<school]} 

{pmore}
	   An example would be 
           {cmd:TeachQuality[school>teacher]} or{break}
           {cmd:TeachQuality[teacher<school]}. 

{pmore}
	   To {cmd:gsem}, 
           {it:Lname}{cmd:[school>teacher]} and 
           {it:Lname}{cmd:[teacher<school]} mean the same thing. 
           You can even refer to 
           {cmd:TeachQuality[school>teacher]} in one place and refer to 
           {cmd:TeachQuality[teacher<school]} in another, and there will 
           be no confusion. 

{pmore}
	   The unobserved values of {it:Lname}{cmd:[school>teacher]} vary 
           across schools and teachers, and they are constant within teacher. 

{pmore}
           If {it:Lname}{cmd:[school>teacher]} is endogenous, its error 
	   variable is{break}
	   {cmd:e.}{it:Lname}{cmd:[school>teacher]} or, equivalently, 
	   {cmd:e.}{it:Lname}{cmd:[teacher<school]}. 

{phang}
1.  Level 1 is the student or observational level.  Latent variables 
           are written as 

{phang3}
	   {it:Lname}{cmd:[school>teacher>student]} or{break}
           {it:Lname}{cmd:[student<teacher<school]} or{break}
           {it:Lname}  

{pmore} 
           Everybody just writes {it:Lname}.  These are the latent variables 
           that correspond to the latent variables that {cmd:sem} provides. 
           Unobserved values within the latent variable vary observation by 
           observation.

{pmore} 
           If {it:Lname} is endogenous, its error variable is
	   {cmd:e.}{it:Lname}.

{pstd}
You can use multilevel latent variables in paths and options just as you would
use any other latent variable; see
{helpb sem and gsem path notation:[SEM] sem and gsem path notation}.
Remember, however, that you must type out the full name of all but the
first-level latent variables.  You type, for instance,
{cmd:SchQual[school>teacher]}.  There is a real tendency to type just
{cmd:SchQual} when the name is unique.

{pstd}
Changing the subject, the names by which effects are referred to  are a
function of the top level.  We just discussed a three-level model.  The three
levels of the model were 

{pmore3}
(3) {cmd:school}{break}
(2) {cmd:school>teacher}{break}
(1) {cmd:school>teacher>student}

{pstd}
If we had a two-level model, the levels would be

{pmore3}
(2) {cmd:teacher}{break}
(1) {cmd:teacher>student}

{pstd}
Thus, if we had started with a two-level model and then wanted to add 
a third, higher level onto it, 
latent variables that were previously referred to as, say, 
{cmd:TeachQual[teacher]} would now be referred to as 
{cmd:TeachQual[school>teacher]}.  


{marker gsem_ext2}{...}
{title:Specifying multilevel crossed latent variables}

{pstd}
In our 
{mansection SEM gsempathnotationextensionsRemarksandexamplesSpecifyingmultilevelnestedlatentvariables:previous example}, we had a three-level
nested model in which student was nested within teacher, which
was nested within school. 

{pstd}
Let's consider data on employees that also have 
the characteristics of working in an occupation and working in an industry. 
These variables are not nested.  Just as before, we will assume we 
have variable {cmd:employee} containing an employee ID, and variables 
{cmd:industry} and {cmd:occupation}.  
The latent variables associated with this model could be 

             Level{col 40}Latent-variable name
             {hline 50}
             occupation{col 40}{it:Lname}{cmd:[occupation]}
             industry{col 40}{it:Lname}{cmd:[industry]}
             employee (observational){col 40}{it:Lname}
             {hline 50}


{marker gsem_ext3}{...}
{title:Specifying family and link}

{pstd}
{cmd:gsem} fits not only linear models but also generalized linear models. 
There is a set of options for specifying the specific model to be fit.
These options are known as family-and-link options, which include
{cmd:family()} and {cmd:link()}, but those options are seldom used in 
favor of other family-and-link shorthand options such as {cmd:logit}, 
which means {cmd:family(bernoulli)} and {cmd:link(logit)}.
These options are explained in
{helpb gsem family and link options:[SEM] gsem family-and-link options}.

{pstd}
In the command language, you can specify these options among the shared 
options at the end of a {cmd:gsem} command:

{phang3}
{cmd:. gsem ..., ... logit ...}

{pstd}
That is convenient, but only if all the equations in the model are using the
same specific response function.  Many models include multiple
equations with each using a different response function.

{pstd}
You can specify any of the family-and-link options within paths. 
For instance, typing 

{phang3}
{cmd:. gsem (y <- x1 x2), logit}

{pstd}
has the same effect as typing 

{phang3}
{cmd:. gsem (y <- x1 x2, logit)}

{pstd}
Thus you can type 

{phang3}
{cmd:. gsem (y1 <- x1 L, logit) (y2 <- x2 L, poisson) ..., ...}

{pstd}
The {cmd:y1} equation would be logit, and the {cmd:y2} equation would be
Poisson.  If you wanted {cmd:y2} to be linear regression, you could type 

{phang3}
{cmd:. gsem (y1 <- x1 L, logit) (y2 <- x2 L, regress) ..., ...}

{pstd}
or you could be silent and let {cmd:y2} default to linear regression, 

{phang3}
{cmd:. gsem (y1 <- x1 L, logit) (y2 <- x2 L) ..., ...}


{marker examples}{...}
{title:Examples}

{title:Examples: Specifying family and link options}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_melanoma}{p_end}

{pstd}Fit a model with the negative binomial family and log link{p_end}
{phang2}{cmd:. gsem (deaths <- uv), family(nbinomial) link(log)}{p_end}

{pstd}Same model as above{p_end}
{phang2}{cmd:. gsem (deaths <- uv), nbreg}{p_end}


{title:Examples: Specifying multilevel models with nested effects}

{pstd}Fit a two-level negative binomial model with a random intercept 
for region{p_end}
{phang2}{cmd:. gsem (deaths <- uv M1[region]), nbreg}{p_end}

{pstd}Fit a three-level negative binomial model with random intercepts for
nation and region nested in nation{p_end}
{phang2}{cmd:. gsem (deaths <- uv M1[nation] M2[nation>region]), nbreg}{p_end}


{title:Examples: Specifying multilevel models with crossed effects}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_fifeschool}

{pstd}Fit a model with crossed random effects for primary and secondary schools{p_end}
{phang2}{cmd:. gsem (attain <- i.sex M1[pid] M2[sid])}{p_end}
