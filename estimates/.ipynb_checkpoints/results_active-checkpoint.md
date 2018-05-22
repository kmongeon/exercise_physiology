

```python
import os
import sys
import shutil
import pandas
import numpy
import json

import ipystata
from ipystata.config import config_stata
config_stata('/usr/local/stata/stata-mp')

pandas.set_option('display.float_format', lambda x: '%.4f' % x)
pandas.set_option('max_columns', 200)
pandas.set_option('max_rows', 400)
pandas.set_option('max_colwidth', 150)
pandas.set_option('mode.sim_interactive', True)
pandas.set_option('colheader_justify', 'center')

from IPython.display import display, display_markdown, Markdown, HTML
# from IPython.display import display, HTML, Image, IFrame, publish_display_data, display_markdown
# from IPython.core.interactiveshell import InteractiveShell
# InteractiveShell.ast_node_interactivity = "all"
# pandas.options.display.float_format = '{:.2f}'.format
```


```python
dm = pandas.read_csv('out/data_analysis.csv')
dm.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: center;">
      <th></th>
      <th>ID</th>
      <th>Sequence</th>
      <th>calo</th>
      <th>height</th>
      <th>weight</th>
      <th>Godin_PA</th>
      <th>id</th>
      <th>season</th>
      <th>session</th>
      <th>gender</th>
      <th>rsos</th>
      <th>tsos</th>
      <th>grip</th>
      <th>ptiso</th>
      <th>biodex</th>
      <th>matlab</th>
      <th>ntxc</th>
      <th>matu</th>
      <th>mvh</th>
      <th>age</th>
      <th>Exclusion</th>
      <th>NoSOS</th>
      <th>NoGrip</th>
      <th>Noptiso</th>
      <th>Nontx</th>
      <th>Nomvh</th>
      <th>T</th>
      <th>_o</th>
      <th>_id</th>
      <th>_v</th>
      <th>size</th>
      <th>_season</th>
      <th>omit</th>
      <th>boys</th>
      <th>girls</th>
      <th>trip</th>
      <th>st_rsos</th>
      <th>st_tsos</th>
      <th>st_grip</th>
      <th>st_ptiso</th>
      <th>st_biodex</th>
      <th>st_matlab</th>
      <th>st_ntxc</th>
      <th>st_calo</th>
      <th>st_matu</th>
      <th>st_mvh</th>
      <th>st_age</th>
      <th>st_height</th>
      <th>st_weight</th>
      <th>st_Godin_PA</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>100</td>
      <td>1</td>
      <td>1572.0000</td>
      <td>152.0000</td>
      <td>44.2000</td>
      <td>37.0000</td>
      <td>100</td>
      <td>spring</td>
      <td>1</td>
      <td>boy</td>
      <td>3828</td>
      <td>3601</td>
      <td>nan</td>
      <td>113.9281</td>
      <td>129.1000</td>
      <td>113.9281</td>
      <td>711.8482</td>
      <td>-1.6700</td>
      <td>105.7100</td>
      <td>11.7500</td>
      <td>none</td>
      <td>nan</td>
      <td>Not taken sequence 1</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>1</td>
      <td>1</td>
      <td>1</td>
      <td>4.0000</td>
      <td>spring</td>
      <td>nan</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>0.1192</td>
      <td>-0.7897</td>
      <td>nan</td>
      <td>-0.2490</td>
      <td>-0.0412</td>
      <td>-0.2490</td>
      <td>0.6525</td>
      <td>-0.0447</td>
      <td>-0.4026</td>
      <td>-0.0322</td>
      <td>-0.0470</td>
      <td>-0.0111</td>
      <td>-0.1331</td>
      <td>-0.9287</td>
    </tr>
    <tr>
      <th>1</th>
      <td>100</td>
      <td>3</td>
      <td>2219.0120</td>
      <td>160.8000</td>
      <td>48.8000</td>
      <td>48.0000</td>
      <td>100</td>
      <td>spring</td>
      <td>3</td>
      <td>boy</td>
      <td>3898</td>
      <td>3629</td>
      <td>27.0000</td>
      <td>136.0238</td>
      <td>138.7000</td>
      <td>136.0238</td>
      <td>760.0939</td>
      <td>-0.7100</td>
      <td>93.6200</td>
      <td>12.7100</td>
      <td>none</td>
      <td>nan</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2</td>
      <td>1</td>
      <td>2</td>
      <td>nan</td>
      <td>NaN</td>
      <td>nan</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>0.8191</td>
      <td>-0.5338</td>
      <td>0.4830</td>
      <td>0.1408</td>
      <td>0.1251</td>
      <td>0.1408</td>
      <td>0.8355</td>
      <td>1.3046</td>
      <td>0.0729</td>
      <td>-0.3233</td>
      <td>0.4354</td>
      <td>0.6353</td>
      <td>0.1856</td>
      <td>-0.6509</td>
    </tr>
    <tr>
      <th>2</th>
      <td>100</td>
      <td>5</td>
      <td>2599.8310</td>
      <td>173.3000</td>
      <td>63.5000</td>
      <td>44.0000</td>
      <td>100</td>
      <td>spring</td>
      <td>5</td>
      <td>boy</td>
      <td>3851</td>
      <td>3677</td>
      <td>37.0000</td>
      <td>177.0531</td>
      <td>178.0000</td>
      <td>177.0531</td>
      <td>543.7346</td>
      <td>0.4100</td>
      <td>98.1400</td>
      <td>13.8300</td>
      <td>none</td>
      <td>nan</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>3</td>
      <td>1</td>
      <td>3</td>
      <td>nan</td>
      <td>NaN</td>
      <td>nan</td>
      <td>1</td>
      <td>0</td>
      <td>3</td>
      <td>0.3491</td>
      <td>-0.0952</td>
      <td>1.8342</td>
      <td>0.8648</td>
      <td>0.8059</td>
      <td>0.8648</td>
      <td>0.0148</td>
      <td>2.0988</td>
      <td>0.6278</td>
      <td>-0.2145</td>
      <td>0.9982</td>
      <td>1.5534</td>
      <td>1.2042</td>
      <td>-0.7519</td>
    </tr>
    <tr>
      <th>3</th>
      <td>100</td>
      <td>7</td>
      <td>2482.1180</td>
      <td>177.4000</td>
      <td>67.3000</td>
      <td>66.0000</td>
      <td>100</td>
      <td>spring</td>
      <td>7</td>
      <td>boy</td>
      <td>3952</td>
      <td>3740</td>
      <td>40.5000</td>
      <td>205.8000</td>
      <td>205.8000</td>
      <td>205.8000</td>
      <td>454.3643</td>
      <td>1.1700</td>
      <td>88.1400</td>
      <td>14.7400</td>
      <td>none</td>
      <td>nan</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>4</td>
      <td>1</td>
      <td>4</td>
      <td>nan</td>
      <td>NaN</td>
      <td>nan</td>
      <td>1</td>
      <td>0</td>
      <td>4</td>
      <td>1.3590</td>
      <td>0.4806</td>
      <td>2.3072</td>
      <td>1.3720</td>
      <td>1.2875</td>
      <td>1.3720</td>
      <td>-0.3241</td>
      <td>1.8533</td>
      <td>1.0043</td>
      <td>-0.4553</td>
      <td>1.4555</td>
      <td>1.8546</td>
      <td>1.4674</td>
      <td>-0.1963</td>
    </tr>
    <tr>
      <th>4</th>
      <td>101</td>
      <td>1</td>
      <td>1549.9930</td>
      <td>158.1000</td>
      <td>47.3000</td>
      <td>25.0000</td>
      <td>101</td>
      <td>spring</td>
      <td>1</td>
      <td>boy</td>
      <td>3682</td>
      <td>3603</td>
      <td>nan</td>
      <td>133.0488</td>
      <td>139.1000</td>
      <td>133.0488</td>
      <td>937.9968</td>
      <td>-1.6300</td>
      <td>89.2900</td>
      <td>11.4500</td>
      <td>none</td>
      <td>nan</td>
      <td>Not taken sequence 1</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>5</td>
      <td>2</td>
      <td>1</td>
      <td>1.0000</td>
      <td>spring</td>
      <td>nan</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>-1.3407</td>
      <td>-0.7715</td>
      <td>nan</td>
      <td>0.0883</td>
      <td>0.1321</td>
      <td>0.0883</td>
      <td>1.5102</td>
      <td>-0.0906</td>
      <td>-0.3828</td>
      <td>-0.4276</td>
      <td>-0.1977</td>
      <td>0.4369</td>
      <td>0.0817</td>
      <td>-1.2317</td>
    </tr>
  </tbody>
</table>
</div>




```python
%%stata 
ssc install JSONIO
```

    
    checking jsonio consistency and verifying not already installed..



```python
%%stata --data dm 
set cformat %9.4f

rename biodex biod
rename st_rsos r
rename st_tsos t
rename st_grip g
rename st_biod b
rename st_matu m
rename st_ntxc n
rename st_calo c
rename st_mvh v

#delimit ;

quietly eststo m1: gsem
    (r <- g@k1   _cons@kk)
    (t <- b@k1 v _cons@kk)
    (r <- m@k2 n@k3  M1[id]@1 _cons@cc) 
    (g b <- m@k4 c@k5 M2[id]@1), 
    covstruct(_lexogenous, diagonal)   
    nocapslatent latent(M1 M2) 
    cov(e.r*e.t) cov(e.g*e.b) cov(M1[id]*M2[id])
    nohead nolog 
    ;
    
#delimit cr

regsave using estimates/result, replace addlabel(M, 1) tstat pval ci level(95) 
regsave using estimates/table, table(M1, order(regvars) format(%9,4f) ) replace
use estimates/table, clear
outsheet using estimates/table.txt, replace

use estimates/result, clear
jsonio out , w(all) filenm(estimates/result.json)
outfile using estimates/statadict, dict replace
```

    
    delimiter now ;>     (r <- g@k1   _cons@kk)
    >     (t <- b@k1 v _cons@kk)
    >     (r <- m@k2 n@k3  M1[id]@1 _cons@cc) 
    >     (g b <- m@k4 c@k5 M2[id]@1), 
    >     covstruct(_lexogenous, diagonal)   
    >     nocapslatent latent(M1 M2) 
    >     cov(e.r*e.t) cov(e.g*e.b) cov(M1[id]*M2[id])
    >     nohead nolog 
    >     ;
    delimiter now crfile estimates/result.dta saved
    file estimates/table.dta saved
    (note: file estimates/statadict.dct not found)



```python
%%stata 

use estimates/result, clear

jsonio out , w(record) filenm(estimates/record.json) 
jsonio out , w(data) filenm(estimates/data.json) 

```

    
    



```python
dr = pandas.read_stata('estimates/result.dta')
dr.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: center;">
      <th></th>
      <th>var</th>
      <th>coef</th>
      <th>stderr</th>
      <th>tstat</th>
      <th>pval</th>
      <th>ci_lower</th>
      <th>ci_upper</th>
      <th>N</th>
      <th>M</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>r:g</td>
      <td>0.3333</td>
      <td>0.0490</td>
      <td>6.8031</td>
      <td>0.0000</td>
      <td>0.2373</td>
      <td>0.4293</td>
      <td>404</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>r:m</td>
      <td>0.0913</td>
      <td>0.0534</td>
      <td>1.7101</td>
      <td>0.0872</td>
      <td>-0.0133</td>
      <td>0.1960</td>
      <td>404</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>r:n</td>
      <td>-0.1911</td>
      <td>0.0444</td>
      <td>-4.3048</td>
      <td>0.0000</td>
      <td>-0.2781</td>
      <td>-0.1041</td>
      <td>404</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>r:M1[id]</td>
      <td>1.0000</td>
      <td>0.0000</td>
      <td>nan</td>
      <td>nan</td>
      <td>1.0000</td>
      <td>1.0000</td>
      <td>404</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>r:_cons</td>
      <td>-0.0136</td>
      <td>0.0612</td>
      <td>-0.2216</td>
      <td>0.8246</td>
      <td>-0.1334</td>
      <td>0.1063</td>
      <td>404</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
dr = pandas.read_stata('estimates/result.dta')
dr = dr.drop(columns=['M'])
dr = dr[['var', 'coef', 'stderr']]
dr = dr.set_index('var')
dr = dr.swapaxes(0,1)
_d = dr.to_dict('series')
_d['r:g']['coef']
```




    0.3332894




```python
_dr = dr.to_dict()
_dr.keys()
```




    dict_keys(['r:g', 'r:m', 'r:n', 'r:M1[id]', 'r:_cons', 't:b', 't:v', 't:_cons', 'g:m', 'g:c', 'g:M2[id]', 'g:_cons', 'b:m', 'b:c', 'b:M2[id]', 'b:_cons', 'var(M1[id]):_cons', 'var(M2[id]):_cons', 'cov(M2[id],M1[id]):_cons', 'var(e.r):_cons', 'var(e.t):_cons', 'var(e.g):_cons', 'var(e.b):_cons', 'cov(e.t,e.r):_cons', 'cov(e.b,e.g):_cons'])




```python
_d['r:g']['coef']
```




    0.3332894




```python
rg = _dr['r:g']['coef']
```




    0.33000001311302185




```python
_dr['r:g']
```




    {'M': 1.0,
     'N': 404.0,
     'ci_lower': 0.23726938664913177,
     'ci_upper': 0.4293094575405121,
     'coef': 0.33000001311302185,
     'pval': 1.0238032643883344e-11,
     'stderr': 0.04899071156978607,
     'tstat': 6.803114414215088}




```python
a = _d['r:g']['coef']
a
```




    0.3332894



Markdown(
"""


"""


```python
from IPython.display import Markdown 

one = 1
two = 2
three = one + two

Markdown("# Title")
Markdown("""
# Math
## Addition
Here is a simple addition example: {one} + {two} = {three}
""".format(one=one, two=two, three=three))

```





# Math
## Addition
Here is a simple addition example: 1 + 2 = 3





```python

```
