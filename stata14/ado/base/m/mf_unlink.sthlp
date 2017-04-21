{smcl}
{* *! version 1.1.2  12sep2013}{...}
{vieweralsosee "[M-5] unlink()" "mansection M-5 unlink()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] io" "help m4_io"}{...}
{viewerjumpto "Syntax" "mf_unlink##syntax"}{...}
{viewerjumpto "Description" "mf_unlink##description"}{...}
{viewerjumpto "Remarks" "mf_unlink##remarks"}{...}
{viewerjumpto "Conformability" "mf_unlink##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_unlink##diagnostics"}{...}
{viewerjumpto "Source code" "mf_unlink##source"}{...}
{title:Title}

{p 4 8 2}
{manlink M-5 unlink()} {hline 2} Erase file


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:        }
{cmd:unlink(}{it:string scalar filename}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:_unlink(}{it:string scalar filename}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{opt unlink(filename)} erases {it:filename} if it exists, does nothing if 
{it:filename} does not exist, and aborts with error if {it:filename} 
exists but cannot be erased.

{p 4 4 2}
{opt _unlink(filename)} does the same, except that, if {it:filename} cannot be 
erased, rather than aborting with error, {cmd:_unlink()} returns 
a negative error code.  {cmd:_unlink()} returns 0 if {it:filename} 
was erased or {it:filename} did not exist.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
To remove directories, see {cmd:rmdir()} in
{bf:{help mf_chdir:[M-5] chdir()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:unlink(}{it:filename}{cmd:)}
          {it:filename}:  1 {it:x} 1
	    {it:result}:  {it:void}

    {cmd:_unlink(}{it:filename}{cmd:)}
          {it:filename}:  1 {it:x} 1
	    {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:unlink(}{it:filename}{cmd:)}
aborts with error when {cmd:_unlink()} would give a negative result.

{p 4 4 2}
{cmd:_unlink(}{it:filename}{cmd:)} returns a negative result if the 
file cannot be erased and returns 0 otherwise.  
If the file did not exist, 0 is returned.
When there is an error, 
most commonly returned are -3602 (filename invalid) or -3621 (file is 
read-only).


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built-in.
{p_end}
