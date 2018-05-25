The repeated sampling of participants resulted in a hierarchical data set that consisted of within (level 1) and between (level 2) measurement variations. Table 1 outlines the variables used in the analysis, their means, and their standard deviations within and between participants. Shapiro-Wilk's tests did not reject the null hypothesis that the radial and tibial bone property distributions are normally distribution. Radial SOS measured an average of 129 points greater than tibial SOS (p=0.00). Girls, on average, has greater bone property measurements than boys; radial SOS by 19 (p=0.0495) and tibial SOS 22 points (0.0376). 

The bone property variances exhibited two distinct characteristics. One is that notable between and within variances existed. Another is that their was greater variation across participants (i.e., between) than across time (i.e., within). The standard deviation of radial SOS measurements across participants (i.e., between) was 86 m/s compared to 51 m/s. The across and with participant standard deviation of tibial SOS was 96 and 50 m/s, respectively. Each independent variable also had a greater between compared to within variance to suggest that a fixed-participant estimation procedure may lead to considerable efficiency loss and a random-participant model is appropriate.

A multilevel structural equation model (i.e., SEM) was developed to describe bone property changes. In brief, SEM is a multivariate statistical technique used to estimate a system of equations and test hypotheses about the relationships among variables. To do so, SEM explicates the direct relationships between observed variables and the covariance relationships between unobserved variables. Models were constructed using Stata 14’s Generalized Structural Equation package (see Kaplan, 2008; Kline, 2015 for an overview of structural equation modeling). 

The functional model of bone development provides the conceptual framework to model bone property changes. This model postulates that specific modulators influence muscle strength, which in turn, along with osteoblasts/osteoclasts related cellular modulators, influence bone properties (see Figure 1). The general SEM to describe bone property changes can be expressed as

\begin{align}
\mathbf{Y_{i,t}} 
&= 
\begin{bmatrix}
y1_{i,t}  \\
y2_{i,t} 
\end{bmatrix}
= \beta_0 \mathbf{\iota} + \mathbf{M_{i,t}'}\beta_1 + \mathbf{Z_{i,t}'} \Theta + \gamma_i \mathbf{\iota} + \epsilon_{i,t} \\
\mathbf{M_{i,t}} 
&= 
\begin{bmatrix}
m1_{i,t}  \\
m2_{i,t} 
\end{bmatrix}
= \Omega_{i,t} W_{i,t} \mathbf{\iota} \ + \delta_i \mathbf{\iota} + \mu_{i,t} 
\end{align}

$ 
\epsilon_{i,t} = 
\begin{bmatrix}
{\epsilon_1}_{i,t}  \\
{\epsilon_2}_{i,t}
\end{bmatrix}
,
\mu_{i,t} =
\begin{bmatrix}
{\mu_1}_{i,t}  \\
{\mu_2}_{i,t}
\end{bmatrix}
, 
\iota_{i,t} =
\begin{bmatrix}
1  \\
1
\end{bmatrix}
$

$ y_{i,t} =  \beta_0 + \beta_1 m_{i,t} + \beta_2 {x_2}_{i,t} + .... + \beta_k {x_k}_{i,t} + \gamma_i + \epsilon_{i,t}$

$ m_{i,t} =  \alpha_0 + \alpha_1 {z_1}_{i,t} + .... + \beta_m {z_m}_{i,t} + \mu_{i,t}$

$ \Sigma = 
\begin{bmatrix}
 \sigma^2_{\epsilon} & \sigma_{\epsilon, \mu}  \\
 \sigma_{\mu, \epsilon} & \sigma^2_{\mu}  \\
\end{bmatrix} $

The $y_{i,t}$ term denotes the $i^{th}$ participant's bone property measurement on the $t^{th}$ occasion. The $m_{i,t}$ term donotes his or her muscle strength, and the ${x_k}_{i,t}$ term donates modulators and control variables. The $\alpha$, and $\beta$ terms denote the unknown fixed parameters, the $\epsilon_{i,t}$ and $\mu_{i,t}$ terms denote the unobserved within-participant (level-1) residuals, and the $\gamma_{i}$ term denotes the unobserved random participant-effects (level 2). The random participant-effects are assumed to be normally distributed with a mean of zero and independent of the muscle strength ($m$) and modulator variables (i.e., $x$). The $\Sigma$ term donates the variance-covariance matrix of the residual terms.

Figure 2 dipicts the bivariate multilevel medidated model implemented. , with obsevered radial and tibial properties. The $\Sigma^W$ and $\Sigma^U$ term denotes the covariances among the within-participant random bone and muscle components. 

