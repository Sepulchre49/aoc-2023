# Solution
Given a race of duration t in ms and x mm, we need to find all of the ways it is
possible to win the race if we charge the boat for c ms before launching.
Keeping in mind that 1 <= c <= t-1, we need to find the lower and upper bounds
of the function x(c) such that x(c) >= d. We can do this using binary search.

We'll start by finding the midpoint of the domain of x(c). This will be one half
the time t. We will evaluate x(c) at time this midpoint to determine if the
midpoint is in the domain of x(c) >= d. If it is, then we continue our binary
search on the left and right sides to find the first point on either side where
the x(c) < d.

If the midpoint is NOT in the domain of x(c) >= d, then we need to determine if
the midpoint was too low or too high. We'll continue by checking the 25th
quartile; if x(t/4) >= d, then we continue as above. Otherwise, we check
x(3t/4). If neither is true, then we repeate with the left and right halves of
t/4 and 3t/4.
