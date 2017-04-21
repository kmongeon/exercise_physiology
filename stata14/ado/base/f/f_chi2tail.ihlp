{* *! version 1.1.1  02mar2015}{...}
    {cmd:chi2tail(}{it:df}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse
	cumulative (upper tail or survivor) chi-squared distribution with
	{it:df} degrees of freedom; {cmd:1} if {it:x} < 0{p_end}

{p2col:}{cmd:chi2tail(}{it:df}{cmd:,}{it:x}{cmd:)} =
	      1 - {cmd:chi2(}{it:df}{cmd:,}{it:x}{cmd:)}{p_end}
{p2col: Domain {it:df}:}2e-10 to 2e+17 (may be nonintegral){p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307; interesting domain is
	{it:x} {ul:>} 0{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}