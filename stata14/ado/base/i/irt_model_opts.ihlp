{* *! version 1.0.0  11feb2015}{...}
{phang}
{opt listwise} handles missing values through listwise deletion, which means
that the entire observation is omitted from the estimation sample if any
of the items are missing for that observation.
By default, all nonmissing items in an observation are included in the
likelihood calculation; only missing items are excluded.
{p_end}
