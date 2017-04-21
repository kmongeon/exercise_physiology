*! version 1.1.0  18jun2009
program define zinb_llf
        version 6.0
	args todo b lnf g H sc1 sc2 sc3

        /* Calculate the log-likelihood */

        tempvar xb zg alpha
	mleval `xb' = `b', eq(1)
	mleval `zg' = `b', eq(2)
	mleval `alpha' = `b', eq(3) scalar

	if `alpha' < -18 { scalar `alpha' = -18 }
	if `alpha' >  18 { scalar `alpha' =  18 }

	scalar `alpha' = exp(`alpha')

	tempname m 
	tempvar p mu
	scalar `m' = 1/`alpha'
	qui gen double `mu' = exp(`xb') if $ML_samp
	qui gen double `p' = 1/(1+`alpha'*`mu') if $ML_samp

	#delimit ;
	mlsum `lnf' = cond($ML_y1 == 0 , 
		ln(1/(1+exp(-`zg')) + 1/(1+exp(`zg'))*`p'^`m'),
		ln(1/(1+exp(`zg'))) + lngamma(`m'+$ML_y1) - 
		lngamma($ML_y1+1) - lngamma(`m') + `m'*ln(`p') + 
		$ML_y1*ln(1-`p') ) ;
	#delimit cr 

	if `todo' == 0 { exit }

	/* Calculate the score and gradient */

	tempvar f1 f2 fz
	qui gen double `f1' = 1/(1+exp(`zg')) if $ML_samp
	qui gen double `f2' = 1-`f1'*(1 - `p'^`m') if $ML_samp
	qui gen double `fz' = exp(`zg')*`f1'*`f1' if $ML_samp
	local y "$ML_y1"

	#delimit ;
	qui replace `sc1' = cond(`y' == 0,
		-(`f1'*`mu'*`p'^(`m'+1))/`f2', 
		`p'*(`y' - `mu') ) if $ML_samp ;
	qui replace `sc2' = cond(`y' == 0 ,
		`fz'*(1-`p'^`m') /`f2',
		-`fz'/`f1') if $ML_samp ;
	qui replace `sc3' = `alpha'*cond(`y' == 0,
		-`f1'*`p'^`m'*(`m'^2*ln(`p')+`m'*`mu'*`p')/`f2', 
		-(`alpha'*`p'*(`mu'-`y') + ln(`p') + 
		digamma(`y'+`m')-digamma(`m')) / 
		(`alpha'^2) ) if $ML_samp ;
	#delimit cr

$ML_ec	tempname db da dg
$ML_ec	mlvecsum `lnf' `db' = `sc1', eq(1)
$ML_ec	mlvecsum `lnf' `dg' = `sc2', eq(2)
$ML_ec	mlvecsum `lnf' `da' = `sc3', eq(3)
$ML_ec	mat cat `g' = `db' `dg' `da'

	if `todo' == 1 { exit }

	/* Calculate the hessian */

	tempname dbdb dbdg dbda dgda dgdg dada
	tempvar ttt
	qui gen double `ttt' = .

	#delimit ;
	qui replace `ttt' = cond(`y' == 0,
		(-`f1'*`mu'*`p'^(`m'+1)*
			(`alpha'*`mu'*(`m'+1)*`p'-1))/`f2' + 
		`sc1'*`sc1',
                `alpha'*`mu'*`p'^2*(`y'-`mu')+`mu'*`p' ) if $ML_samp ;
	mlmatsum `lnf' `dbdb' = `ttt', eq(1) ; 
		
	qui replace `ttt' = cond(`y' == 0,
		-`fz'*`mu'*`p'^(`m'+1) / `f2' -
		`f1'*`mu'*`p'^(`m'+1)*`fz'*(1-`p'^`m') / (`f2'*`f2') ,
		0 ) if $ML_samp ;
	mlmatsum `lnf' `dbdg' = `ttt', eq(1,2) ;
		
	qui replace `ttt' = cond(`y' == 0,
		(-`f1'*`mu'*`p'^(`m'+1)*((`m'+1)*`mu'*`p'+
			`m'*`m'*ln(`p')))/`f2' + 
		`f1'*`f1'*`mu'*`p'^(2*`m'+1)*(`m'*`mu'*`p'+
			`m'*`m'*ln(`p'))/(`f2'*`f2'),
                `mu'*`p'^2*(`y'-`mu') ) if $ML_samp ;
	mlmatsum `lnf' `dbda' = `ttt'*`alpha', eq(1,3) ; 
		

	qui replace `ttt' = cond(`y' == 0 ,
		-(1-exp(`zg'))*`f1'*`fz'*(1-`p'^`m') / `f2' + 
		(`fz'*(1-`p'^`m') / `f2')^2 , 
		(1-exp(`zg'))*`f1'*`fz'/`f1' + (`fz'/`f1')^2) if $ML_samp ;
	mlmatsum `lnf' `dgdg' = `ttt', eq(2) ;

	qui replace `ttt' = cond(`y' == 0,
		-`fz'/`f2'*(1+(1-`p'^`m')*`f1'/`f2')*
		`p'^`m'*(`m'*`m'*ln(`p')+`m'*`mu'*`p'), 
		0 ) if $ML_samp ;
	mlmatsum `lnf' `dgda' = `ttt'*`alpha', eq(2,3) ;
		
	qui replace `ttt' = cond(`y' == 0 ,
		-`f1'*`p'^`m'*`alpha'*`alpha'*(
				(`m'^2*ln(`p')+`m'*`mu'*`p')^2 + 
				2*`m'^3*ln(`p')+2*`m'*`m'*`mu'*`p'+
				`m'*`mu'*`mu'*`p'*`p' 
		)/`f2' + `sc3'*`sc3' - `sc3',
                `m'*(-ln(`p')-digamma(`y'+`m')+digamma(`m')) -
                `m'^2*(trigamma(`y'+`m')-trigamma(`m')) - `mu'*`p' +
                `mu'*`p'^2*(`y'-`mu')/`m') if $ML_samp ;
	
	mlmatsum `lnf' `dada' = `ttt', eq(3) ;

	mat cat `H' =	`dbdb'  `dbdg'  `dbda' \ 
			`dbdg'' `dgdg'  `dgda' \
			`dbda'' `dgda'' `dada' ;
	#delimit cr
end