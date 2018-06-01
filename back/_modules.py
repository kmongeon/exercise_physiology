import pandas
import numpy
import ipystata
from ipystata.config import config_stata
config_stata('/usr/local/stata/stata-mp')

pandas.set_option('display.float_format', lambda x: '%.4f' % x)
pandas.set_option('precision', 4)
pandas.set_option('max_columns', 400)
pandas.set_option('mode.sim_interactive', True)
pandas.set_option('colheader_justify', 'center')

from IPython.display import HTML, Markdown, Latex, Image