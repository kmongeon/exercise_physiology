*! version 1.0.2  24nov2014

version 10.1

mata
mata set matastrict on

/* random chi-squared(df) variate generatator				*/
real matrix rchi2(real scalar r, real scalar c, real matrix df)
{
	return(rgamma(r,c,df:/2,2.0))
}

real matrix rchi2_kiss32(real scalar r, real scalar c, real matrix df)
{
        return(rgamma_kiss32(r,c,df:/2,2.0))
}

real matrix rchi2_mt64(real scalar r, real scalar c, real matrix df)
{
        return(rgamma_mt64(r,c,df:/2,2.0))
}

end
exit

