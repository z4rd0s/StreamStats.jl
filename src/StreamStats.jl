module StreamStats

using OffsetArrays
using Statistics
using StatsBase
using JSON

function monte_carlo_pi(data)
    """
    Calculate Monte Carlo Pi approximation for a given byte array.
    Keyword arguments:
    data -- data bytes
    """
    set_length::Int32 = round((length(data) / 2) - 1)
    r_square::Int16 = 128^2
    circle_surface::Float16 = 0

    for i in 1:set_length
        (data[i*2] - 128)
        if ((data[i*2] - 128) ^ 2 + (data[i*2+1] - 128) ^ 2) <= r_square
            circle_surface += 1
        end
    end
    return 4 * circle_surface / set_length
end

function pi_deviation(pi_value)
    """
    Returns an absolute percentage of difference between the provided Pi
    value and canonic.
    Keyword arguments:
    pi_value -- Pi value to be tested for difference
    """
    return abs(100 - (pi_value * 100 / pi))
end

function chi_squared(data)
    """Calculate Chi-Squared value for a given byte array.
    Keyword arguments:
    data -- data bytes
    """
    expected = length(data) / 256
    observed = OffsetVector([0 for i in 0:255], 0:255)

    for b in data
        observed[b] += 1
    end

    chi_squared = 0
    for o in observed
        chi_squared += (o - expected) ^ 2 / expected
    end

    return chi_squared
end

function get_all(data)
    """
    Returns a set of Statistical Information about the data
    Keywird arguments:
    data -- data bytes
    """
    carlo = monte_carlo_pi(data)
    dist = StatsBase.countmap(data)
    ddist = Dict{Int32,Int32}()
    for i in 0:255
        if Base.haskey(dist,i)
          ddist[i] = dist[i]
        else
          ddist[i] = 0
        end
    end

    orderd_dist =  sort(collect(dist), by=x->x[1])

    return JSON.json(Dict{String, Any}([
                "length"         => length(data),
                "chi-squared"    => chi_squared(data),
                "min"            => Int(Statistics.minimum(data)),
                "max"            => Int(Statistics.maximum(data)),
                "mean"           => Statistics.mean(data),
                "median"         => Statistics.median(data),
                "middle"         => Statistics.middle(data),
                "standard-dev"   => StatsBase.std(data),
                "kurtosis"       => StatsBase.kurtosis(data),
                "cor"            => Int(StatsBase.cor(data)),
                "skewness"       => StatsBase.skewness(data),
                "variation"      => StatsBase.variation(data),
                "sem"            => StatsBase.sem(data),
                "entropy"        => StatsBase.entropy(data),
                "cov"            => StatsBase.cov(data),
                "mad"            => StatsBase.mad(data, normalize=false),
                "monte-carlo-pi" => carlo,
                "pi-deviation"   => pi_deviation(carlo),
                "distribution"   => orderd_dist
                ])
            )
end

Base.@ccallable function julia_main()::Cint
    try
        main()
    catch
        Base.invokelatest(Base.display_error, Base.catch_stack())
        return 1
    end
    return 0
end

function main()
    println(ARGS)
    for file in ARGS
        if !isfile(file)
            error("could not find file $file")
        end
        println(get_all(read(file)))
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

end