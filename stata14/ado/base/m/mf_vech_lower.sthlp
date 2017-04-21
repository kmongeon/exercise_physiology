{smcl}
{* *! version 1.0.2  18feb2015}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] manipulation" "help m4_manipulation"}{...}
{vieweralsosee "[M-5] vech()" "help mf_vech"}{...}
{viewerjumpto "Syntax" "mf_vec##syntax"}{...}
{viewerjumpto "Description" "mf_vec##description"}{...}
{viewerjumpto "Example" "mf_vec##example"}{...}
{viewerjumpto "Conformability" "mf_vec##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_vec##diagnostics"}{...}
{viewerjumpto "Source code" "mf_vec##source"}{...}
{title:Title}

{p2colset 5 27 29 2}{...}
{p2col :{hi:[M-5] vech_lower()} {hline 2}}Stack matrix columns{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:transmorphic colvector}
{cmd:vech_lower(}{it:transmorphic matrix T}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:vech_lower(}{it:T}{cmd:)} returns square and typically symmetric
matrix {it:T} transformed into a column vector; only the lower half of 
the matrix without the main diagonal is recorded.


{marker example}{...}
{title:Example}

        {cmd:: x}
        [symmetric]
               1   2   3
            {c TLC}{hline 13}{c TRC}
          1 {c |}  1          {c |}
          2 {c |}  2   4      {c |}
          3 {c |}  3   6   9  {c |}
            {c BLC}{hline 13}{c BRC}

        {cmd:: v = vech_lower(x)}
        {cmd:: v}
               1
            {c TLC}{hline 5}{c TRC}
          1 {c |}  2  {c |}
          2 {c |}  3  {c |}
          3 {c |}  6  {c |}
            {c BLC}{hline 5}{c BRC}


{marker conformability}{...}
{title:Conformability}

    {cmd:vech_lower(}{it:T}{cmd:)}:
                  {it:T}:   {it:n x n}
             {it:result}:   ({it:n}*({it:n}-1)/2) {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:vech_lower(}{it:T}{cmd:)} aborts with error if {it:T} is not square.
{cmd:vech_lower()} records only the lower triangle of {it:T} without the main
diagonal; it does not require that {it:T} be symmetric.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view vech_lower.mata, adopath asis:vech_lower.mata}
{p_end}
