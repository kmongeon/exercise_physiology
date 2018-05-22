Ron:

Would you be able to assist me with expressing a bivariate multivel mediated model in matrix notation? The model consists of two mediated models. Four equations in total: two regression equations ($y1$ and $y2$) and two mediated equations ($m1$ and $m2$). $y1$ is radial bone properties,  $y2$ is tibial bone properties, $m1$ is grip strength and $m2$ is knee strength. $Z$ and $W$ are exgenous variables. Grip strength mediates the effects of $W$ on radial bone properties and knee strength mediates the effect of $W$$ on tibial bone properties. 

All equations includes include random-individual effects; $\gamma_i$ in the regression equations and $\delta_i$ in the mediated equations. The random-individual effects are correlated across the regression and mediated equations (i.e., correlated random effects models). The regression equation residuals are correlated, and the mediation equations are corrected (i.e., seemingly unrelated models). 

The base specification restricts the coefficents to equal across the regression equations and mediated equations, repectively. Without matricies the models can be expressed as:

$ 
y1_{i,t} = \beta_0 + \beta_1 m1_{i,t} + \Theta Z_{i,t}' \Theta + \gamma_{i} + \epsilon1_{i,t} 
$ 

$ 
m1_{i,t} = \Omega W_{i,t} + \delta_{i} + \mu1_{i,t} 
$

$ 
y2_{i,t} = \beta_0 + \beta_1 m2_{i,t} + \Theta Z_{i,t}' \Theta + \gamma_{i} + \epsilon2_{i,t} 
$

$ 
m2_{i,t} = \Omega W_{i,t} + \delta_{i} + \mu2_{i,t} 
$

$ 
\Sigma = 
\begin{bmatrix}
 \sigma^2_{\epsilon1} & \sigma_{\epsilon1, \epsilon2}  \\
 \sigma_{\epsilon2, \epsilon1} & \sigma^2_{\epsilon2}  \\
\end{bmatrix} 
$

$ 
\Sigma = 
\begin{bmatrix}
 \sigma^2_{\mu1} & \sigma_{\mu1, \mu2}  \\
 \sigma_{\mu2, \mu1} & \sigma^2_{\mu2}  \\
\end{bmatrix} 
$

$ 
\Sigma = 
\begin{bmatrix}
 \sigma^2_{\gamma} & \sigma_{\gamma, \delta}  \\
 \sigma_{\delta, \gamma} & \sigma^2_{\delta}  \\
\end{bmatrix} 
$

I would like to express the entire model using matricies: $\mathbf{Y}$ represents both $y1_{i,t}$ and $y2_{i,t}$ and $\mathbf{M}$ represents both $m1_{i,t}$ and $m2_{i,t}$. Make sense?

