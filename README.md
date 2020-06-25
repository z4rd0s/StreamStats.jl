# StreamStats
Julia functions to calculate

* Shannon Entropy
* Monte Carlo Pi-Deviation
* Chi-Squard

## Installation Steps
1. Install [julia](https://julialang.org/) from source or with your preferred
   package manager.
```
using Pkg
Pkg.add("https://github.com/z4rd0s/StreamStats.jl")
```
## Usage
1. Execute julia
```
using StreamStats

random(n) = rand(UInt8, n)
data = StreamStats.get_all(random(1000))
```

# Usage from python
## Install
1. `python3 -m venv .venv && source .venv/bin/activate`
2. `pip install -r requirements.txt`
3. `python -c "import julia; julia.install()"`

## Usage
```Python
Python 3.6.10 (default, Jan 16 2020, 09:12:04) [GCC] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
>>> from julia.api import Julia
>>> Julia(compiled_modules=False)
>>> from julia import StreamStats
>>> import os
>>> data = bytearray(os.urandom(10))
>>> stats = StreamStats.get_all(data)
```
