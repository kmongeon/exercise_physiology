{* *! version 1.2.1  12mar2015}{...}
    {cmd:strreverse(}{it:s}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}reverses the ASCII string {it:s}{p_end}

{p2col:}{cmd:strreverse()} is intended for use with only
	{mansection I Glossaryplainascii:plain ASCII} characters.
	For Unicode characters beyond ASCII range (code point greater
	than 127), the 
	{mansection I Glossaryencode:encoded} bytes are reversed.{p_end}

{p2col:}To reverse the characters of 
	{mansection I Glossaryunichar:Unicode string}, see
	{helpb f_ustrreverse:ustrreverse()}.{p_end}

{p2col:}{cmd:strreverse("hello")} = {cmd:"olleh"}{p_end}
{p2col: Domain {it:s}:}ASCII strings{p_end}
{p2col: Range:}ASCII reversed strings{p_end}
{p2colreset}{...}
