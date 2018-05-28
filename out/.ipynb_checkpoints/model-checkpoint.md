The repeated sampling of participants resulted in a hierarchical data set that consisted of within (level 1) and between (level 2) measurement variations. Table 1 outlines the variables used in the analysis, their means, and their standard deviations within and between participants. Shapiro-Wilk's tests did not reject the null hypothesis that the radial and tibial bone property distributions are normally distribution. Radial SOS measured an average of 129 points greater than tibial SOS (p=0.00). Girls, on average, has greater bone property measurements than boys; radial SOS by 19 (p=0.0495) and tibial SOS 22 points (0.0376). 

The bone property variances exhibited two distinct characteristics. One is that notable between and within variances existed. Another is that their was greater variation across participants (i.e., between) than across time (i.e., within). The standard deviation of radial SOS measurements across participants (i.e., between) was 86 m/s compared to 51 m/s. The across and with participant standard deviation of tibial SOS was 96 and 50 m/s, respectively. Each independent variable also had a greater between compared to within variance to suggest that a fixed-participant estimation procedure may lead to considerable efficiency loss and a random-participant model is appropriate.

The functional model of bone development provides the conceptual framework to model bone property changes. Rather than a direct causal effect between modulators and bone properties, the functional model of bone development postulates that modulators inflence muscle strength, which in turn influences bone properties (see Figure 1). A multilevel structural equation model  (i.e., SEM) was developed to test the intrinusic relationships between modulators, muscle strength, and bone properties. 
In brief, SEM is a multivariate statistical technique used to estimate a system of equations and test hypotheses about the relationships among variables. To do so, SEM explicates the direct relationships between observed variables and the covariance relationships between unobserved variables. Models were constructed using Stata 14’s Generalized Structural Equation package (see Kaplan, 2008; Kline, 2015 for an overview of structural equation modeling). 

The general SEM to describe bone property changes can be expressed as

$$
\begin{align}
\mathbf{Y_{i,t}} 
&=  
\beta_0 \mathbf{\iota} + \mathbf{M_{i,t}'}\beta_1 + \mathbf{Z_{i,t}'} \Theta + \gamma_i \mathbf{\iota} + \epsilon_{i,t} \\
\mathbf{M_{i,t}} 
&= 
\Omega W_{i,t} \mathbf{\iota} \ + \delta_i \mathbf{\iota} + \mu_{i,t} \\
\end{align}
$$

The $\mathbf{Y_{i,t}}$ denotes $i^{th}$ participant's bone property measurement on the $t^{th}$ occasion, and the $\mathbf{M_{i,t}}$ term donotes his or her muscle strength measurement. The $\mathbf{Z_{i,t}'}$ and $\mathbf{W_{i,t}'}$ terms are matricies of modulators and control variables that potentials influence bone property or muscle strength changes. The $\beta$, and $\Omega$ terms denote the unknown fixed parameters, the $\epsilon_{i,t}$ and $\mu_{i,t}$ terms denote the unobserved within-participant (level-1) residuals, and the $\gamma_{i}$ term denotes the unobserved random participant-effects (level 2). The random participant-effects are assumed to be normally distributed with a mean of zero and independent of the covariates. 


In the case of two bone property and muscle strength measurements, the model can be expressed as 
$\mathbf{Y_{i,t}} = 
\begin{bmatrix}
    {y_1}_{i,t}  \\
    {y_2}_{i,t} 
\end{bmatrix}$
, where ${y_1}_{i,t}$ and ${y_2}_{i,t}$ denote radial SOS and tibial SOS measurements, and 
$\mathbf{M_{i,t}} =
\begin{bmatrix}
    {m_1}_{i,t}  \\
    {m_2}_{i,t} 
\end{bmatrix}$
, where ${m_1}_{i,t}$ and ${m_2}_{i,t}$ denote the isometric grip strength and knee extensor measurements. In the two dimensional case $ \epsilon_{i,t} = \begin{bmatrix}
    {\epsilon_1}_{i,t}  \\
    {\epsilon_2}_{i,t}
\end{bmatrix}
, \hspace{2mm}
\mu_{i,t} =
\begin{bmatrix}
    {\mu_1}_{i,t}  \\
    {\mu_2}_{i,t}
\end{bmatrix}$ and $\Sigma
= 
\begin{bmatrix}
    \sigma^2_{\epsilon_1} & \sigma_{\epsilon_1, \epsilon_2}  \\
    \sigma_{\epsilon_2, \epsilon_1} & \sigma^2_{\epsilon_2}  \\
\end{bmatrix} 
, \hspace{2mm}
\Psi
= 
\begin{bmatrix}
    \sigma^2_{\mu_1} & \sigma_{\mu_1, \mu_2}  \\
    \sigma_{\mu_2, \mu_1} & \sigma^2_{\mu_2}  \\
\end{bmatrix} $, where $\Sigma$ denotes the variance-covariance matrix between the bone property residuals and $\Psi$ denotes the variance-covariance matrix between the muscle strength residuals. The $
\iota_{i,t} =
\begin{bmatrix}
    1  \\
    1
\end{bmatrix}$ term ensures the matricies conform. 




