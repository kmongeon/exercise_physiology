*! version 1.0.2  17mar2016
version 9.0
mata:

/*
	uniqrows(transmorphic matrix x)
	uniqrows(transmorphic matrix x, real scalar 0)

	return sorted, unique list.
	
	uniqrows(transmorphic matrix x, real scalar !0)
	
	return sorted, unique list with frequency counts.
	The returned matrix has an extra column that contains the counts.
*/

transmorphic matrix uniqrows(transmorphic matrix x, |real scalar freq)
{
	real scalar		i, j, n, ns
	real vector		count
	transmorphic matrix 	sortx, res

	if (rows(x)==0) return(J(0,cols(x), missingof(x)))
	if (cols(x)==0) return(J(1,0, missingof(x)))

	if (args() == 1) {
		freq = 0
	}
	
	sortx = sort(x, 1..cols(x))
	ns = 1
	n = rows(x)
	for (i=2;i<=n;i++) {
		if (sum(sortx[i-1,]:!=sortx[i,])) ns++
	}
	res = J(ns, cols(x), sortx[1,1])
	res[1,] = sortx[1,]

	if (freq) count = J(ns,1,1)
	
	for (i=j=2;i<=n;i++) {
		if (sum(sortx[i-1,] :!= sortx[i,])) {
			res[j++,] = sortx[i,]
		}
		else {
			if (freq) {
				count[j-1] = count[j-1]+1
			}
		}
	}	
	
	if (freq) res = res,count
	return(res)
}

end
