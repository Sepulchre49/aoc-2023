# Solution Walkthrough

## The Problem
Currently, the approach that I used is intractable for the number of inputs in
the second part of the challenge. So, I need to find a way to reduce the input
space considerably.

The key to this problem is that each layer represents a function with a domain
and range which can be split into disjoint intervals of integers. Take the
following sample input:
```
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
```

Here, the input consists of the set [79, 83] U [55, 67]. Taking Z to be the set
of positive integers Z = [0, \infty), the first layer (seed-to-soil) is a
function f(x) whose domain can be divided into the following subsets:


A = [98, 99]
B = [50, 97]
C = Z - A U B = [0, 49] U [100, \infty)

The range of f(x) can also be divided into the following subsets:
D = [50, 51]
E = [52, 99]
F = Z - D U F = [0, 49] U 100, \infty)

So, f(x) maps A -> D, B -> E, C -> F. However, the domain is restricted by the
number of set of inputs. We can further divide up the domain and range of f by
finding the intersection of the input with the domain of f. Let X = [79, 83] and
Y = [55, 67]. Then, the domain and range of f can be properly defined as the
following subsets:

A * X = {}
A * Y = {}

B * X = [79, 83]
B * Y = [55, 67]

C * X = {}
C * Y = {}

Therefore, f(x)'s domain maps the following intervals to the following
intervals:
X = [79, 83] -> [81, 85]
Y = [55, 67] -> [57, 69]

These X, Y sets become the input to the next layer. Take g(x) to be the function
describing the next layer of mapping (soil-to-fertilizer). g(x) maps the
following subsets of the domain to the following subsets of the range:

A = [15, 51] -> [ 0, 36]
B = [52, 53] -> [37, 38]
C = [ 0, 14] -> [39, 54]
D = Z - A U B U C 
  = [54, \infty) -> [54, \infty)

Again, we have to restrict the domain by the outputs of the previous layer:

X = [81, 85]
Y = [57, 69]

A * X = {}
A * Y = {}

B * X = {}
B * Y = {}

C * X = {}
C * Y = {}

D * X = [81, 85]
D * Y = [57, 69]

Since D maps each input to itself, the range of this layer is [81, 85] U [56,
69].

Going to the next layer (fertilizer-to-water), take h(x) to be the function
representing this layer. We have the following domain and range for h(x):

A = [53, 60] -> [49, 56]
B = [11, 52] -> [ 0, 41]
C = [ 0,  6] -> [42, 48]
D = [ 7, 10] -> [57, 60]
E = Z - A U B U C U D
  = [61, \infty) -> [61, \infty)

Restricting the domain by the previous layer's input:
X = [81, 85]
Y = [56, 69]

A * X = {}
A * Y = [56, 60] -> [52, 56]

B * X = {}
B * Y = {}

C * X = {}
C * Y = {}

D * X = {}
D * Y = {}

E * X = [81, 85] -> [81, 85]
E * Y = [61, 69] -> [61, 69]

So, the range of h(x) is [52, 56] U [81, 85] U [61, 69]

Moving forward one more layer, we take i(x) (water-to-light) to be the function
representing this layer with the following domain and range:

A = [18, 24] -> [88, 94]
B = [25, 94] -> [18, 87]
C = Z - A U B
  = [ 0, 17] U [95, \infty)

The range of the previous layer was:
W = [52, 56]
X = [81, 85]
Y = [61, 69]

So the real domain and range of this layer is:
A * W = {}
A * X = {}
A * Y = {}

B * W = [52, 56] -> [45, 49]
B * X = [81, 85] -> [74, 78]
B * Y = [61, 69] -> [54, 62]

C * W = {}
C * x = {}
C * Y = {}

So, the range of this layer is [45, 49] U [74, 78] U [54, 62].

Suppose that i(x) represents the final layer. Then, if we the function F(x) to
be the function mapping the domain of seeds to the range of i(x), then it is
clear the value which minimizes F can be found by comparing the minimum values
of each of the subsets of the range and choosing the smallest one.

How do we keep track of which original inputs caused these outputs though?

