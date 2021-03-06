# StreamStats
Julia functions to calculate

* Shannon Entropy
* Monte Carlo Pi-Deviation
* Chi-Squard

## Installation Steps
1. Install [julia](https://julialang.org/) from source or with your preferred
   package manager.
```
julia -e 'using Pkg; Pkg.add(PackageSpec(url="https://github.com/z4rd0s/StreamStats.jl"))'
```
# Usage from julia
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
>>> data = bytearray(os.urandom(1000))
>>> stats = StreamStats.get_all(data)
```

# Usage as Binary
## Creating Binary
1. Precompile StreamStats.jl
```bash
cd bin
cp ../src/StreamStats.jl .
julia --startup-file=no --trace-compile=StreamStats_precompile.jl StreamStats.jl "<anyfile.bin>example.pdf"
```

2. Generate Custom Julia Image containing Precompiled
```bash
julia --startup-file=no -J"<path to julia/sys.so>/usr/share/julia-1.4.2/lib/julia/sys.so" --output-o StreamStats-sys.o StreamStats_image_generator.jl
```
```bash
gcc -shared -o StreamStats-sys.so -fPIC -Wl,--whole-archive StreamStats-sys.o -Wl,--no-whole-archive -L"<path to julia/lib>/usr/share/julia-1.4.2/lib/" -ljulia
```

3. Building the executable
```bash
gcc -DJULIAC_PROGRAM_LIBNAME=\"StreamStats-sys.so\" -o StreamStats.bin StreamStats.c StreamStats-sys.so -O2 -fPIE -I'<path to julia>/usr/share/julia-1.4.2/include/julia' -L'<path to julia binary>/usr/share/julia-1.4.2/lib' -ljulia -Wl,-rpath,'<path to julia binary at remote destination>/usr/share/julia-1.4.2/lib:$ORIGIN'
```

4. Run the executable
StreamStats.bin and StreamStats-sys.so must be executed within the same directory
```bash
$ ./StreamStats.bin <path to any file>
```

## Calling Binary from python
```Python
import subprocess
import logging
import json

def run(cmd: str) -> bool:
    """Executes a command line locally

    :param cmd: The command line string
    :type cmd: str
    :return: Returns True if the commandline could be exectued
                successfully, otherwise False
    :rtype: bool
    """
    try:
        proc = subprocess.Popen(
                cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, error = proc.communicate(timeout=15)

        if proc.returncode == 0:
            return output
        logging.error("Command <%s> failed", cmd)
        return False
    except subprocess.TimeoutExpired:
        proc.kill()
        logging.error("Command <%s> timed out", cmd, exc_info=True)
        return False
    except Exception:
        logging.error("Command <%s> failed", cmd, exc_info=True)
        return False

cmd_StreamStats = ["./bin/StreamStats.bin", "./bin/example.pdf"]
data = json.loads(run(cmd_StreamStats))
```