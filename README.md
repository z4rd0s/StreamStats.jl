# StreamStats
Julia functions to calculate

* Shannon Entropy
* Monte Carlo Pi-Deviation
* Chi-Squard

## Installation Steps
1. install julia  -> https://julialang.org/
1. execute julia
```
using Pkg
pkg.add("https://github.com/z4rd0s/StreamStats.jl")
```
## Usage
1. execute julia
```
using StreamStats
data = [random_values]
chi = StreamStats.chi_squared(data)
shanon = StreamStats.compute_shanon(data)
carlo = StreamStats.compute_monte_carlo(data)
```

