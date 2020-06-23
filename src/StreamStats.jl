module StreamStats

using OffsetArrays

function compute_shanon(data)
    """
    Calculate Shannon entropy value for a given byte array.
        Keyword arguments:
        data -- data bytes
    """
    entropy::Float16 = 0
    d = Array([(count(x->x==i,data)) for i in data])
    for i in d
        it = float(i/length(data))
        if i > 0
            entropy += - it * log(it ,2)
        end
    end
    return entropy
end

function compute_monte_carlo(data)
    """
    Calculate Monte Carlo Pi approximation for a given byte array.
    Keyword arguments:
    data -- data bytes
    """
    set_length::Int32 = (length(data) / 2) - 1
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

function get_pi_deviation(pi_value)
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

end
