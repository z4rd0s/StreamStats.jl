# StreamStats
Julia functions to calculate

* Shannon Entropy
* Monte Carlo Pi-Deviation
* Chi-Squard

## Installation Steps
1. Install [julia](https://julialang.org/) from source or with your preferred
   package manager.
2. Execute julia and enter the builtin package manager with pressing `]`
```
(v1.0) pkg> add https://github.com/z4rd0s/StreamStats.jl
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

# Usage from python
## Install
1. `python -m venv .venv && source .venv/bin/activate` 
1. `pip install -r requirements` 
1. `python -c "import julia; julia.install()"`

## Usage
``` 
from julia.api import Julia 
jl = Julia(compiled_modules=False) 
from julia import StreamStats

data = [random_values]
chi = StreamStats.chi_squared(data)
shanon = StreamStats.compute_shanon(data)
carlo = StreamStats.compute_monte_carlo(data)
```
