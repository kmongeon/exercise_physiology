{smcl}
{* *! version 1.0.3  17feb2015}{...}
{vieweralsosee "[PSS] power" "help power"}{...}
{vieweralsosee "[PSS] Glossary" "help pss_glossary"}{...}
{viewerjumpto "Power error codes" "power_errors##errors"}{...}
{title:Why does the power table have missing entries?}

{pstd}
You executed the {manhelp power PSS:power} command for a set of multiple
values and received a table containing missing entries.  Missing entries in
the power table indicate that the computation failed for some combinations of
the specified values of parameters.  This happens most typically when you
specify an overlapping set of values for the
{help pss_glossary##def_nullval:null parameter} and the 
{help pss_glossary##def_altval:alternative parameter}, such as

{pstd}
{cmd: . power onemean (0 1) (1 2)}
{p_end}

    Performing iteration ...

    Estimated sample size for a one-sample mean test
    t test
    Ho: m = m0  versus  Ha: m != m0

      +---------------------------------------------------------+
      |   alpha   power       N   delta      m0      ma      sd |
      |---------------------------------------------------------|
      |     .05      .8      10       1       0       1       1 |
      |     .05      .8       5       2       0       2       1 |
      |     .05      .8       .       0       1       1       1 |
      |     .05      .8      10       1       1       2       1 |
      +---------------------------------------------------------+
      Warning: some of the computations failed; execute each 
               computation separately to see the specific error

{pstd}
The value for the sample size {cmd:N} in the third row is missing.  To
investigate what caused this computation to fail, we can look at the 
matrix of errors by typing

{pstd}
{cmd:. matrix list r(error_codes)}

    r(error_codes)[1,4]
        c1  c2  c3  c4
    r1   0   0  14   0

{pstd}
The third column of the matrix contains the error code 14.  We can find the
corresponding description of this error in the 
{help power_errors##errors:table} below of errors produced by the {cmd:power}
command.  The error code 14 corresponds to the error situation "difference is
invalid", which may arise in a number of situations but typically means that
the specified reference and comparison values are the same.

{pstd}
To identify the specific situation for which this error occurred, we rerun the
{cmd:power} command using the values of parameters from the third row.

{pstd}
{cmd: . power onemean 1 1}
{p_end}
{pstd}
{red:null and alternative means are equal; this is not allowed}{p_end}
{pstd}{search r(198):r(198);}{p_end}

{pstd}
The specified values for the null mean and the alternative mean are the same,
which the {cmd:power onemean} command does not allow.


{marker errors}{...}
{title:Power error codes and error descriptions}

{p2colset 9 20 22 2}{...}
{synopt:Error}{p_end}
{synopt:code}Error text{p_end}
{p2line}
{synopt :0}(no error encountered){p_end}

{synopt :10-39}input errors{p_end}
{synopt :11}sample size is invalid{p_end}
{synopt :12}correlation is invalid{p_end}
{synopt :13}mean is invalid{p_end}
{synopt :14}difference is invalid{p_end}
{synopt :15}ratio is invalid{p_end}
{synopt :16}finite population correction is invalid{p_end}
{synopt :17}proportion is invalid{p_end}
{synopt :18}variance or standard deviation is invalid{p_end}
{synopt :19}proportion sum is invalid{p_end}
{synopt :20}covariance matrix is not positive definite{p_end}
{synopt :21}null contrast is equal to C*mu{p_end}
{synopt :22}delta is too small{p_end}
{synopt :23}odds ratio is invalid{p_end}
{synopt :24}hazard ratio is invalid{p_end}
{synopt :25}log hazard-ratio is invalid{p_end}
{synopt :26}correlation is too extreme{p_end}
{synopt :27}power is too small{p_end}
{synopt :28}hazard is invalid{p_end}
{synopt :29}coefficient is invalid{p_end}
{synopt :30}trend is invalid{p_end}

{synopt :40-69}computation errors{p_end}
{synopt :41}computed sample size invalid{p_end}
{synopt :42}computed proportion invalid{p_end}
{synopt :43}computed difference invalid{p_end}
{synopt :44}computed correlation invalid{p_end}
{synopt :45}computed repeated-measures Geisser-Greenhouse correction
	invalid{p_end}
{synopt :46}computed sample size less than 2{p_end}
{synopt :50}initial value for the iterative search is invalid{p_end}
{synopt :51}sample size initial value exceeds the population size{p_end}
{synopt :55}operation is invalid for this computation{p_end}
{synopt :60}power computation failed{p_end}
{synopt :61}computed sample size did not achieve the target power{p_end}

{synopt :70-99}iterative solution errors{p_end}
{synopt :74}initial value is a missing value{p_end}
{synopt :76}maximum iterations reached{p_end}
{synopt :77}missing values encountered when evaluating the power function{p_end}
{synopt :89}power function could not be evaluated at the initial values{p_end}
{synopt :90}derivatives could not be computed at the initial values{p_end}
{synopt :91}search found a local minimum of the power{p_end}
{synopt :92}derivatives could not be calculated{p_end}
{synopt :97}fatal error occurred in the power function{p_end}
{p2line}
{p2colreset}{...}
