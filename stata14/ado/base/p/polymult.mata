*! version 1.0.0  11jan2005
version 9.0
mata:

numeric rowvector polymult(numeric rowvector ca, numeric rowvector cb) 
{
	numeric rowvector	res 
	real rowvector		prefix
	real scalar		i, na, nb

	if ((na=cols(ca))==0 | (nb=cols(cb))==0) _error(3200)

	res    = cb[1] :* ca
	prefix = 0
	for (i=2; i<=nb; i++) {
		res    = (res,0) + (prefix, cb[i]:*ca)
		prefix = (prefix, 0)
	}
	return(res) 
}

end
