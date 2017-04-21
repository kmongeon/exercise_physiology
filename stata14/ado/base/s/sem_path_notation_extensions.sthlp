{smcl}
{* *! version 2.0.1  31may2013}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem path notation extensions" "mansection SEM sempathnotationextensions"}{...}
{vieweralsosee "[SEM] intro 2" "mansection SEM intro2"}{...}
{vieweralsosee "[SEM] intro 6" "mansection SEM intro6"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation"}{...}
{viewerjumpto "Syntax" "sem_path_notation_extensions##syntax"}{...}
{viewerjumpto "Description" "sem_path_notation_extensions##description"}{...}
{viewerjumpto "Options" "sem_path_notation_extensions##options"}{...}
{viewerjumpto "Remarks" "sem_path_notation_extensions##remarks"}{...}
{viewerjumpto "Examples" "sem_path_notation_extensions##examples"}{...}
{title:Title}

{p2colset 5 43 45 2}{...}
{p2col:{manlink SEM sem path notation extensions} {hline 2}}Command syntax for
path diagrams{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {it:paths} ... [{cmd:,} {opt covariance()} {opt variance()} 
            {opt means()} [{opth group(varname)}]]

{pstd}
{it:paths} specifies the direct paths between the variables of your model.

{pstd}
The model to be fit is fully described by {it:paths}, 
{opt covariance()}, {opt variance()}, and {opt means()}.

{pstd}
The syntax of these elements is modified (generalized) when the
{cmd:group()} option is specified.


{marker description}{...}
{title:Description}

{pstd}
This entry concerns {cmd:sem} only.

{pstd}
The command syntax for describing your SEMs is fully
specified by {it:paths}, {opt covariance()}, {opt variance()}, and 
{opt means()}.  How that works is described in
{helpb sem and gsem path notation:[SEM] sem and gsem path notation}.
See that section before reading this section.

{pstd}
This entry concerns the path features unique to {cmd:sem}, and
that has to do with the {cmd:group()} option for comparing different
groups.


{marker options}{...}
{title:Options}

{phang}
{opt covariance()},
{opt variance()}, and
{opt means()} are described in
{helpb sem and gsem path notation:[SEM] sem and gsem path notation}.

{phang}
{opth group(varname)}
allows models specified with {it:paths}, {cmd:covariance()}, {cmd:variance()},
and {cmd:means()} to be automatically generalized (interacted) with the groups
defined by {it:varname}; see {manlink SEM intro 6}.  The syntax of {it:paths}
and the arguments of {cmd:covariance()}, {cmd:variance()}, and {cmd:means()}
gain an extra syntactical piece when {cmd:group()} is specified.


{marker remarks}{...}
{title:Remarks}

{pstd}
The model you wish to fit is fully described by the {it:paths},
{cmd:covariance()}, {cmd:variance()}, and {cmd:means()} that you type. 
The {opt group(varname)} option,

{phang3}
{cmd:. sem ..., ... group(}{it:varname}{cmd:)}

{pstd}
specifies that the model be fit separately for the different values
of {it:varname}.  {it:varname} might be {cmd:sex} and then the model would be
fit separately for males and females, or {it:varname} might be something
else and perhaps take on more than two values.

{pstd}
Whatever {it:varname} is, {opt group(varname)} defaults to letting some
of the path coefficients, covariances, variances, and means of your model vary
across the groups and constraining others to be equal.  Which parameters vary
and which are constrained is described in
{helpb sem group options:[SEM] sem group options}, but that
is a minor detail right now.

{pstd}
In what follows, we will assume that {it:varname} is {cmd:mygrp} and takes on
three values.  Those values are 1, 2, and 3, but they could just as well be 2,
9, and 12.

{pstd}
Consider typing 

{phang3}
{cmd:. sem ..., ...}

{pstd}
and typing 
  
{phang3}
{cmd:. sem ..., ... group(mygrp)}

{pstd}
Whatever the {it:paths}, {cmd:covariance()}, {cmd:variance()}, and
{cmd:means()} are that describe the model, there are now three times as many
parameters because each group has its own unique set.  In fact, when you give
the second command, you are not merely asking for three times the parameters,
you are specifying three models, one for each group!  In this case, you
specified the same model three times without knowing it.

{pstd}
You can vary the model specified across groups. 

{marker syntax_item1}{...}
{phang}
1.  Let's write the model you wish to fit as 

{phang3}
{cmd:. sem} {cmd:(}{it:a}{cmd:)} {cmd:(}{it:b}{cmd:)} {cmd:(}{it:c}{cmd:),}
        {cmd:cov(}{it:d}{cmd:)} {cmd:cov(}{it:e}{cmd:)} {cmd:var(}{it:f}{cmd:)}

{pmore}where {it:a}, {it:b}, ..., {it:f} stand for what 
            you type.  In this generic example, we have two {cmd:cov()} 
            options just because multiple {cmd:cov()} options often occur 
            in real models.
            When you type 

{phang3}
{cmd:. sem} {cmd:(}{it:a}{cmd:)} {cmd:(}{it:b}{cmd:)} {cmd:(}{it:c}{cmd:),}
       {cmd:cov(}{it:d}{cmd:)} {cmd:cov(}{it:e}{cmd:)} {cmd:var(}{it:f}{cmd:)}
       {cmd:group(mygrp)}

{pmore}results are as if you typed 

{phang3}
{cmd:. sem (1:} {it:a}{cmd:) (2:} {it:a}{cmd:) (3:} {it:a}{cmd:)}{space 22}///{break}
      {cmd:(1:} {it:b}{cmd:) (2:} {it:b}{cmd:) (3:} {it:b}{cmd:)}{space 24}///{break}
      {cmd:(1:} {it:c}{cmd:) (2:} {it:c}{cmd:) (3:} {it:c}{cmd:),}{space 23}///{break}
   {cmd:cov(1:} {it:d}{cmd:) cov(2:} {it:d}{cmd:) cov(3:} {it:d}{cmd:)}{space 15}///{break}
   {cmd:cov(1:} {it:e}{cmd:) cov(2:} {it:e}{cmd:) cov(3:} {it:e}{cmd:)}{space 15}///{break}
   {cmd:var(1:} {it:f}{cmd:) cov(2:} {it:f}{cmd:) cov(3:} {it:f}{cmd:)} {cmd:group(mygrp)}

{pmore}
     The {cmd:1:}, {cmd:2:}, and {cmd:3:} identify the groups for which 
            paths, covariances, or variances are being added, modified, 
            or constrained.  

{pmore}
     If {cmd:mygrp} contained the unique values 5, 8, and 10 instead
            of 1, 2, and 3, then {cmd:5:} would appear in place of 
            {cmd:1:}; {cmd:8:} would appear in place of {cmd:2:}; 
            and {cmd:10:} would appear in place of {cmd:3:}.

{phang}
2.  Consider the model 

{phang3}
{cmd:. sem (y <- x) (}{it:b}{cmd:) (}{it:c}{cmd:), cov(}{it:d}{cmd:) cov(}{it:e}{cmd:) var(}{it:f}{cmd:) group(mygrp)}

{pmore}
    If you wanted to constrain the path coefficient {cmd:(y <- x)} to 
             be the same across all three groups, you could type 

{phang3}
{cmd:. sem (y <- x@c1) (}{it:b}{cmd:) (}{it:c}{cmd:), cov(}{it:d}{cmd:) cov(}{it:e}{cmd:) var(}{it:f}{cmd:) group(mygrp)}

{pmore}
See item {help sem and gsem path notation##item12:12}
	     in {helpb sem and gsem path notation:[SEM] sem and gsem path notation} for more examples of
	     specifying constraints.  This works because the expansion of
	     {cmd:(y <- x@c1)} is 

{phang3}
{cmd:(1: y <- x@c1) (2: y <- x@c1) (3: y <- x@c1)}
             
{marker syntax_item3}{...}
{phang}
3.  Consider the model 

{phang3}
{cmd:. sem (y <- x) (}{it:b}{cmd:)} {cmd:(}{it:c}{cmd:),} {cmd:cov(}{it:d}{cmd:)} {cmd:cov(}{it:e}{cmd:)} {cmd:var(}{it:f}{cmd:) group(mygrp)}

{pmore}
    If you wanted to constrain the path coefficient {cmd:(y <- x)} to be the
             same in groups 2 and 3, you could type

{phang3}
{cmd:. sem (1: y <- x) (2: y <- x@c1) (3: y <- x@c1) (}{it:b}{cmd:) (}{it:c}{cmd:),}      ///{break}
     {cmd:cov(}{it:d}{cmd:) cov(}{it:e}{cmd:) var(}{it:f}{cmd:) group(mygrp)}

{marker syntax_item4}{...}
{phang}
4.  Instead of following
          item {help sem path notation extensions##syntax_item3:3},
           you could type

{phang3}
{cmd:. sem (y <- x) (2: y <- x@c1) (3: y <- x@c1) (}{it:b}{cmd:) (}{it:c}{cmd:),}        ///{break}
   {cmd:cov(}{it:d}{cmd:)} {cmd:cov(}{it:e}{cmd:) var(}{it:f}{cmd:) group(mygrp)}

{pmore}
The part {cmd:(y <- x) (2: y <- x@c1) (3: y <- x@c1)}
expands to 

{phang3}
{cmd:(1: y <- x) (2: y <- x) (3: y <- x) (2: y <- x@c1) (3: y <- x@c1)}

{pmore}
and thus the path is defined twice for group 2 and twice for
             group 3.  When a path is defined more than once, the definitions
             are combined.  In this case, the second definition adds more
             information, so the result is as if you typed 

{phang3}
{cmd:(1: y <- x) (2: y <- x@c1) (3: y <- x@c1)}

{marker syntax_item5}{...}
{phang}
5.  Instead of following
          item {help sem path notation extensions##syntax_item3:3}
          or
          item {help sem path notation extensions##syntax_item4:4},
          you could type 

{phang3}
{cmd:. sem (y <- x@c1) (1: y <- x@c2) (}{it:b}{cmd:) (}{it:c}{cmd:),}      ///{break}
      {cmd:cov(}{it:d}{cmd:)} {cmd:cov(}{it:e}{cmd:)}
      {cmd:var(}{it:f}{cmd:)} {cmd:group(mygrp)}

{pmore}
The part {cmd:(y <- x@c1) (1: y <- x@c2)} expands to 

{phang3}
{cmd:(1: y <- x@c1)  (2: y <- x@c1)  (3: y <- x@c1)  (1: y <- x@c2)}

{pmore}
When results are combined from repeated definitions, then definitions
             that appear later take precedence.  In this case, results are 
             as if the expansion read 

{phang3}
{cmd:(1: y <- x@c2) (2: y <- x@c1)  (3: y <- x@c1)}
             
{pmore}
Thus coefficients for groups 2 and 3 are constrained. 
              The group-1 coefficient is constrained to {cmd:c2}.  If {cmd:c2}
              appears nowhere else in the model specification, then results 
              are as if the path for group 1 were unconstrained.

{marker syntax_item6}{...}
{phang}
6.  Instead of following
          item {help sem path notation extensions##syntax_item3:3},
          item {help sem path notation extensions##syntax_item4:4},
          or
          item {help sem path notation extensions##syntax_item5:5},
          you could not type

{phang3}
{cmd:. sem (y <- x@c1) (1: y <- x) (}{it:b}{cmd:) (}{it:c}{cmd:),}
///{break}
       {cmd:cov(}{it:d}{cmd:) cov(}{it:e}{cmd:) var(}{it:f}{cmd:)}
       {cmd:group(mygrp)}

{pmore}
The expansion of {cmd:(y <- x@c1) (1: y <- x)} reads

{phang3}
{cmd:(1: y <- x@c1)  (2: y <- x@c1)  (3: y <- x@c1)  (1: y <- x)}

{pmore}
and you might think that {cmd:1: y <- x} would replace
             {cmd:1: y <- x@c1}.  Information, however, is combined, and even
             though precedence is given to information appearing later,
             silence does not count as information.  Thus the expanded 
             and reduced specification reads the same as if {cmd:1: y <- x}
             was never specified:
              
{phang3}
{cmd:(1: y <- x@c1)  (2: y <- x@c1)  (3: y <- x@c1)}

{phang}
7.  Items {help sem path notation extensions##syntax_item1:1} through
          {help sem path notation extensions##syntax_item6:6},
             stated in terms of {it:paths}, apply 
             equally to what is typed inside the {cmd:means()}, 
             {cmd:variance()}, and {cmd:covariance()} options.
             For instance, if you typed

{phang3}
{cmd:. sem (}{it:a}{cmd:) (}{it:b}{cmd:) (}{it:c}{cmd:), var(e.y@c1)}
       {cmd:group(mygrp)}

{pmore}
then you are constraining the variance to be equal across all
             three groups.

{pmore}
If you wanted to constrain the variance to be equal in groups2
             and 3, you could type

{phang3}
{cmd:. sem (}{it:a}{cmd:) (}{it:b}{cmd:) (}{it:c}{cmd:), var(e.y)}
        {cmd:var(2: e.y@c1) var(3: e.y@c1), group(mygrp)}

{pmore}
You could omit typing {cmd:var(e.y)} because it is implied.
             Alternatively, you could type 

{phang3}
{cmd:. sem (}{it:a}{cmd:) (}{it:b}{cmd:) (}{it:c}{cmd:), var(e.y@c1)}
        {cmd:var(1: e.y@c2) group(mygrp)}

{pmore}
You could not type 

{phang3}
{cmd:. sem (}{it:a}{cmd:) (}{it:b}{cmd:) (}{it:c}{cmd:), var(e.y@c1)}
     {cmd:var(1: e.y) group(mygrp)}

{pmore}
because silence does not count as information when specifications
             are combined.

{pmore}
Similarly, if you typed

{phang3}
{cmd:. sem (}{it:a}{cmd:) (}{it:b}{cmd:) (}{it:c}{cmd:), cov(e.y1*e.y2@c1)}
      {cmd:group(mygrp)}

{pmore}
then you are constraining the covariance to be equal across 
             all groups.  If you wanted to constrain the covariance to be 
             equal in groups 2 and 3, you could type 

{phang3}
{cmd:. sem (}{it:a}{cmd:) (}{it:b}{cmd:) (}{it:c}{cmd:), cov(e.y1*e.y2)}{space 13}///{break}
       {cmd:cov(2: e.y1*e.y2@c1) cov(3: e.y1*e.y2@c1)} ///{break}
       {cmd:group(mygrp)}

{pmore}
You could not omit {cmd:cov(e.y1*e.y2)} because it is not 
             assumed.  By default, error variables are assumed to be
             uncorrelated.  Omitting the option would constrain the covariance
             to be 0 in group 1 and to be equal in groups 2 and 3.

{pmore}
Alternatively, you could type 

{phang3}
{cmd:. sem (}{it:a}{cmd:) (}{it:b}{cmd:) (}{it:c}{cmd:),}
          {cmd:cov(e.y1*e.y2@c1)}                       ///{break}
          {cmd:cov(1: e.y1*e.y2@c2) group(mygrp)}

{phang}
8.  In the examples above, we have referred to the groups with 
           their numeric values, 1, 2, and 3.  Had the values been
           5, 8, and 10, then we would have used those values.

{pmore}
If the group variable {cmd:mygrp} has a value label, 
           you can use the label to refer to the group.  
           For instance, imagine {cmd:mygrp} is labeled as follows: 

{phang3}
{cmd:. label define grpvals 1 Male  2 Female  3 "Unknown sex"}{p_end}
{phang3}
{cmd:. label values mygrp grpvals}

{pmore}
We could type 

{phang3}
{cmd:. sem (y <- x) (Female: y <- x@c1) (Unknown sex: y <- x@c1) ..., ...}

{pmore}
or we could type 

{phang3}
{cmd:. sem (y <- x) (2: y <- x@c1) (3: y <- x@c1) ..., ...}


{marker examples}{...}
{title:Examples}

{title:Examples: Specifying a multiple group model}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}A simple regression model{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length)}{p_end}

{pstd}Specify groups{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length), group(foreign)}{p_end}

{pstd}Alternative notation to above{p_end}
{phang2}{cmd:. sem (0: mpg <- turn trunk length)}{break}
	{cmd: (1: mpg <- turn trunk length), group(foreign)}{p_end}


{title:Examples: Specifying means(), covariance(), and variance() options with groups}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmmby}{p_end}

{pstd}Measurement model with groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4), group(grade)}{p_end}

{pstd}Constrain the mean of {cmd:Peer} to 0 in both groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
 	{cmd:group(grade) mean(Peer@0)}{p_end}

{pstd}Same as above{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
        {cmd:group(grade) mean(1:Peer@0) mean(2:Peer@0)}{p_end}

{pstd}Estimate the covariance between errors of {cmd:parrel1} and 
{cmd:parrel2} in group 1{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
        {cmd:group(grade) covariance(1:e.parrel1*e.parrel2)}{p_end}

{pstd}Constrain the variance of {cmd:Par} to be equal in the two groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
        {cmd:group(grade) variance(1:Par@v) variance(2:Par@v)}{p_end}
