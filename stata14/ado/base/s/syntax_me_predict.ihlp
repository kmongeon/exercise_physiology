{* *! version 1.0.1  12jan2015}{...}
{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{pstd}
Syntax for obtaining predictions of the outcome and other statistics

{p 8 16 2}
{cmd:predict} {dtype} {it:newvarsspec} {ifin} 
[{cmd:,} {it:{help meglm_postestimation##statistic:statistic}}
{it:{help meglm_postestimation##options_table:options}}]


{p 4 4 2}
Syntax for obtaining estimated random effects and their standard errors

{p 8 16 2}
{cmd:predict} {dtype} {it:newvarsspec} {ifin}{cmd:,} {opt reffects}
[{it:{help meglm_postestimation##re_options:re_options}}]


{pstd}
Syntax for obtaining ML scores

{p 8 16 2}
{cmd:predict} {dtype} {it:newvarsspec} {ifin}{cmd:,} {opt sc:ores}


{pstd}
{it:newvarsspec} is {it:stub}{cmd:*} or {it:{help newvarlist}}.
