The estimation results are summarized in Table 2. All level-1 fixed
effects and level-2 random effects were found to be significant at the
0.01 level. To facilitate straightforward comparison of the causal
effects, all variables were transformed/standar dized to a mean of zero
and standard deviation of one. Conclusions based on non-standardized
values support identical inferences.

The results are consistent with the relationships postulated by the
functional model of bone development. Physical maturity and nutrition
influence muscle strength, which in-turn, along osteoclast activity, and
physical maturity influences bone properti es. Although physical
maturation has both direct and indirect impacts bone properties,
physical maturation and muscle strength had similar total impact. In
terms of standard unit changes, the direct impact of muscle strength and
physical maturation on b one pro

          . esttab ALL BOYS GIRLS, ///
           keep(r:g r:m r:n r:_cons g:m g:c g:_cons var(M1[id]):_cons var(M2[id]):_cons cov(M2[id],M1[id]):_cons ) ///
           label b(%9.4f) se(%9.4f)  nostar ///
           nodepvars nonumbers parentheses noeqlines compress nonotes ///
           mtitles("All" "Boys" "Girls") ///
           title("Table 2. Estiamtion results") ///
           addnotes("Notes: Standard errors in parentheses. All level-1 fixed effects and level-2 random effects were found to be significant at the 0.05 level") ///
           coeflabels(var(M1[id]):_cons "Bone equations" var(M2[id]):_cons "Muscle equations" cov(M2[id],M1[id]):_cons "Covariance") ///
           varwidth(20) modelwidth(15)


          Table 2. Estiamtion results
          --------------------------------------------------------------------
                                           All            Boys           Girls
          --------------------------------------------------------------------
          Bone properties                                                     
          Muscle strength               0.2924          0.2017          0.3654
                                      (0.0624)        (0.1006)        (0.0964)

          Physical maturation           0.1806          0.1577          0.2258
                                      (0.0536)        (0.1167)        (0.0700)

          Ntx creatine                 -0.1749         -0.1726         -0.1611
                                      (0.0326)        (0.0465)        (0.0460)

          Constant                     -0.0388         -0.0926          0.0258
                                      (0.0535)        (0.0910)        (0.0897)

          Muscle strength                                                     
          Physical maturation           0.6241          0.9996          0.5594
                                      (0.0323)        (0.0390)        (0.0408)

          Energy intake                 0.0843          0.0148          0.0524
                                      (0.0270)        (0.0258)        (0.0403)

          Constant                      0.0209          0.5326         -0.3887
                                      (0.0495)        (0.0563)        (0.0487)

          var(M1[id])                                                         
          Bone equations                0.3949          0.3439          0.4263
                                      (0.0542)        (0.0678)        (0.0820)

          var(M2[id])                                                         
          Muscle equations              0.3607          0.2328          0.0724
                                      (0.0472)        (0.0392)        (0.0270)

          cov(M2[id],M1[id])                                                  
          Covariance                   -0.0952          0.0209         -0.0687
                                      (0.0447)        (0.0456)        (0.0340)
          --------------------------------------------------------------------
          Observations                     404             209             195
          --------------------------------------------------------------------
          Notes: Standard errors in parentheses. All level-1 fixed effects and level-2 random effects were found to be significant at the 0.05 level
