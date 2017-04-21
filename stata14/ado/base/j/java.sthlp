{smcl}
{* *! version 1.0.5  12dec2016}{...}
{vieweralsosee "[P] java" "mansection P java"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "javacall" "help javacall"}{...}
{vieweralsosee "Stata-Java API Specification" "browse http://www.stata.com/java/api14"}{...}
{vieweralsosee "Java Platform, Standard Edition 8 API Specification" "browse http://docs.oracle.com/javase/8/docs/api/"}{...}
{viewerjumpto "Description" "java##description"}{...}
{viewerjumpto "Usage" "java##usage"}{...}
{viewerjumpto "Remarks" "java##remarks"}{...}
{viewerjumpto "Example" "java##example"}{...}
{title:Title}

{p2colset 5 17 20 2}{...}
{p2col :{manlink P java} {hline 2}}Java plugins{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Java plugins are Java programs that you can call from Stata.
When called from Stata, a Java plugin has the ability to interact 
with Stata's dataset, matrices, macros, scalars, and more.
Programmers familiar with Java can leverage Java's extensive
language features.  There are also many third-party libraries
available.  If you are not an experienced Java programmer and 
you intend to implement a Java plugin, you should start by learning to
program Java.  Once you become a proficient Java programmer, writing
a Java plugin for Stata should be relatively easy.


{marker usage}{...}
{title:Usage}

{pstd}
Java programs are compiled into class files and optionally bundled
into Java Archive (JAR) files.  Class files and JAR files must be
placed in the correct location for the Java Runtime Environment (JRE)
to find them.  The JRE relies on the Java classpath for this task.
When Stata initially loads the JRE, the classpath is set to reflect Stata's
{help sysdir:ado-path}.  All class and JAR files must be located within
Stata's ado-path or in a directory named {cmd:jar} within the ado-path.
For example, if your personal directory is 
{cmd:C:\ado\personal\}, then you would need to place your compiled Java files
in {cmd:C:\ado\personal\} or {cmd:C:\ado\personal\jar\}.  Similarly, all other
ado-path directories and {cmd:jar} directories along the ado-path are added
to the Java classpath when the JRE is initially loaded.

{pstd}
A typical Java stand-alone program has an entry point through a {cmd:main()}
method, which looks like this:

{pin2}
	{cmd:static void main(String[] args)}

{pstd}
To call a Java plugin from Stata, you must define a similar entry point.
However, there are two important distinctions.  First, you may name your method
whatever you like as long as it conforms to standard Java naming requirements.
Second, your method must have a return type of {cmd:int} instead of
{cmd:void}.  Here is an example of a valid method signature that Stata can
call:

{pin2}
	{cmd:static int mymethod(String[] args)}

{pstd}
Let's assume that {cmd:mymethod()} really exists and the compiled Java files
have been placed in an appropriate location.  To call {cmd:mymethod()}, we use
Stata's {helpb javacall} command.  {cmd:javacall} allows you to invoke any
static method in the classpath if that method follows the correct signature
as described above.

{pstd}
For a Java plugin to be useful, it needs to have access to certain
functionality in Stata.  We provide Java packages to address those needs.
Refer to
{browse "http://www.stata.com/java/api14/":Java-Stata API Specification}
for details.


{marker remarks}{...}
{title:Remarks}

{pstd}
When a programmer is developing and testing a Java program, it is
important to understand when the JRE is
loaded and its effect.  

{pstd}
The JRE loads the first time that it is needed.  That can happen 
if internal Stata functionality requires Java or if Java is needed
for some user-written command.  Java's classpath is set when the
JRE is loaded, and it cannot be modified afterward (that is, modifying the
ado-path after the JRE has loaded will not change the classpath).  
For the end user who is consuming a completed Java plugin, the process
of how Java plugins are loaded is not important because it happens
transparently.  However, for the programmer who is modifying and testing
code, it is very important to understand the process.  

{pstd}
Assume you are implementing a Java method named {cmd:mymethod()}.  You have
compiled it, placed the class or JAR file in the correct location,
and call it for the first time using {helpb javacall}.  Perhaps it 
executes correctly, but you want to make some modification. You 
edit the source code, compile it, and copy it to the correct location.
If you are using the same Stata session, your changes will not be reflected
when you call it again.  To reload a Java plugin, Stata must be restarted.

{pstd}
If you intend to redistribute your Java plugin through Stata's
{helpb net} command, you must always bundle your compiled program into
a JAR file.  This is important because {cmd:net} copies {cmd:.class} files
as text instead of binary because of text-based Stata {help class} files.


{marker example}{...}
{title:Example}

{pstd}
Consider two variables that store integers too large to be stored 
accurately in a {help datatype:double} or a {help datatype:long},
so instead they are stored as {help datatype:strings}.  If we 
needed to subtract the values in one variable from another, 
we could write a plugin utilizing Java's BigInteger class.  
The following code shows how we could perform the task:
  
    /* Java class begins here */
    import java.math.BigInteger;
    import com.stata.sfi.*;
    class MyClass {
       /* Define the static method with the correct signature */
       public static int sub_string_vals(String[] args) {
	  long nobs1 = Data.getObsParsedIn1() ;
	  long nobs2 = Data.getObsParsedIn2() ;
	  BigInteger b1, b2 ;

	  if (Data.getParsedVarCount() != 2) {
	      SFIToolkit.error("Exactly two variables must be specified\n") ;
	      return(198) ;
	  }
	  if (args.length != 1) {
	      SFIToolkit.error("New variable name not specified\n") ;
	      return(198) ;
	  }

	  if (Data.addVarStr(args[0], 10)!=0) {
	      SFIToolkit.error("Unable to create new variable " + args[0] + "\n") ;
	      return(198) ;
	  }

	  // get the real indexes of the varlist
	  int mapv1 = Data.mapParsedVarIndex(1) ;
	  int mapv2 = Data.mapParsedVarIndex(2) ;
	  int resv  = Data.getVarIndex(args[0]) ;

	  if (!Data.isVarTypeStr(mapv1) || !Data.isVarTypeStr(mapv2)) {
	      SFIToolkit.error("Both variables must be strings\n") ;
	      return(198) ;
	  }

	  for(long obs=nobs1; obs<=nobs2; obs++) {
	      // Loop over the observations

	      if (!Data.isParsedIfTrue(obs)) continue ;
	      // skip any observations omitted from an [if] condition
	      try {
	          b1 = new BigInteger(Data.getStr(mapv1, obs)) ;
	          b2 = new BigInteger(Data.getStr(mapv2, obs)) ;
	          Data.storeStr(resv, obs, b1.subtract(b2).toString()) ;
	      }
	      catch (NumberFormatException e) { }
	  }
	  return(0) ;		
       }
    }
    /* Java class ends here */
    
{pstd}
Consider the following data, containing two string variables with
four observations:

    . {cmd:list}
    
         +-----------------------------------------+
         |               big1                 big2 |
         |-----------------------------------------|
      1. |  29811231010193176    29811231010193168 |
      2. |  42981123101023696    42981123101023669 |
      3. | -98121437010116560   -98121437010116589 |
      4. |               1000                  999 |
         +-----------------------------------------+
         
{pstd}
Next we call the Java method using {helpb javacall}.  The two variables to
subtract are passed in as a {varlist}, and the name of the new variable is
passed in as a single argument using {opt args(argument_list)}.

    . {cmd:javacall MyClass sub_string_vals big1 big2, args(result1)}

    . {cmd:list}

         +---------------------------------------------------+
         |               big1                 big2   result1 |
         |---------------------------------------------------|
      1. |  29811231010193176    29811231010193168         8 |
      2. |  42981123101023696    42981123101023669        27 |
      3. | -98121437010116560   -98121437010116589        29 |
      4. |               1000                  999         1 |
         +---------------------------------------------------+

