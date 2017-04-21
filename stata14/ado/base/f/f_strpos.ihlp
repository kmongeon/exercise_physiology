{* *! version 1.1.3  24mar2015}{...}
    {cmd:strpos(}{it:s1}{cmd:,}{it:s2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the position in {it:s1} at which {it:s2} is
                     first found; otherwise, {cmd:0}{p_end}
		     
{p2col:}{cmd:strpos()} is intended for use with only
	{mansection I Glossaryplainascii:plain ASCII} characters and for
	use by programmers who want to obtain the byte-position of {it:s2}. 
	Note that any Unicode character beyond ASCII range (code point greater
	than 127) takes more than 1 byte in the UTF-8 encoding; for example,
	{cmd:é} takes 2 bytes.{p_end}

{p2col:}To find the character position of {it:s2} in a
	{mansection I Glossaryunichar:Unicode string}, see
	{helpb f_ustrpos:ustrpos()}.{p_end}


{p2col:}{cmd:strpos("this","is")} = {cmd:3}{break}
	{cmd:strpos("this","it")} = {cmd:0}{p_end}
{p2col: Domain {it:s1}:}strings (to be searched){p_end}
{p2col: Domain {it:s2}:}strings (to search for){p_end}
{p2col: Range:}integers {ul:>} 0{p_end}
{p2colreset}{...}
