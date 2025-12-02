#!/usr/bin/env julia
filename = length(ARGS) > 0 ? ARGS[1] : "example"

function is_invalid(code)
    s = string(code)
    l = length(s)
    return s[1:div(l, 2)] == s[div(l, 2)+1:l]
end

input = open(filename, "r") do f
    read(f, String) |>
    chomp |>
    s -> split(s, ',') .|>
    s -> split(s, '-') |>
    r -> parse.(Int, r[1]):parse.(Int, r[2])
end

invalids =  collect(Iterators.flatten(input .|> filter(is_invalid)))
print("Part 1: ", sum(invalids), "\n")

function split_string(s, n)
    chars = collect(s)
    return [join(chunk) for chunk in Iterators.partition(chars, n)]
end

function is_invalid2(code)
    s = string(code)
    l = length(s)

    return 1 in (1:(div(l,2)) .|> i -> split_string(s, i) |> unique |> length)
end

invalids =  collect(Iterators.flatten(input .|> filter(is_invalid2)))
print("Part 1: ", sum(invalids), "\n")