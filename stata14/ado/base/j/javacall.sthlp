{smcl}
{* *! version 1.0.4  12dec2016}{...}
{vieweralsosee "[P] javacall" "mansection P javacall"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "java" "help java"}{...}
{vieweralsosee "Stata-Java API Specification" "browse http://www.stata.com/java/api14/"}{...}
{vieweralsosee "Java Platform, Standard Edition 8 API Specification" "browse http://docs.oracle.com/javase/8/docs/api/"}{...}
{viewerjumpto "Syntax" "javacall##syntax"}{...}
{viewerjumpto "Description" "javacall##description"}{...}
{viewerjumpto "Option" "javacall##option"}{...}
{title:Title}

{p2colset 5 21 20 2}{...}
{p2col :{manlink P javacall} {hline 2}}Call a static Java method{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt javacall} {it:class} {it:method} [{varlist}] {ifin}
   [{cmd:,} {opt args(argument_list)}]


{marker description}{...}
{title:Description}

{pstd}
{opt javacall} calls a static Java method.  The {it:method} to be called
must be implemented with a specific Java signature, and the signature must
be in the following form:

	{cmd:static int} {it:java_method_name}{cmd:(String[] args)}

{pstd}
{cmd:javacall} requires the {it:class} to be a fully 
qualified name that includes the class's package specification.  
For example, to call a method named {bf:method1} from
class {bf:Class1}, which was part of package {bf:com.mydomain}, 
the following would be used:

	{com}. javacall com.mydomain.Class1 method1{txt}
	
{pstd}
Optionally, a {varlist}, {helpb if} condition, or {helpb in} condition
may be specified.  Stata provides a Java package containing various
classes and methods allowing access to the {it:varlist}, {cmd:if}, and
{cmd:in}; see {helpb java:[P] java} for more details.


{marker option}{...}
{title:Option}

{phang}
{opt args(argument_list)} specifies the {it:argument_list}
that will be passed to the Java method as a string array.
If {opt args()} is not specified, the array will be empty.
{p_end}
