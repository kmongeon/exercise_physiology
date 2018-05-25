% Dynamic Documents with Stata and Markdown
% Germán Rodríguez, Princeton University
% 4 November 2017

Let us read the fuel efficiency data that is shipped with Stata


{{1}}


To study how fuel efficiency depends on weight it is useful to
transform the dependent variable from "miles per gallon" to
"gallons per 100 miles"


{{2}}


We then obtain a more linear relationship

![Fuel Efficiency](auto.png){width="4.5in"}

which was plotted using the commands


{{3}}


The regression equation estimated by OLS is


{{4}}

    
Thus, a car that weights 1,000 lbs more than another requires on
average an extra {{.5}} gallons to travel 100 
miles.
    
That's all for now!
