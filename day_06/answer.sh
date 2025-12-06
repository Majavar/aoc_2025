#!/usr/bin/env bash

jq -Rrs '
    "Part 1: " + (
        gsub("^\\s+|\\s+$"; "") |
        split("\n") |
        map(gsub("^\\s+|\\s+$"; "")) |
        map(gsub(" +"; " ")) |
        map(split(" ")) |
        transpose |
        map(
            if .[-1] == "+" then .[:-1] | map(tonumber) | add
            elif .[-1] == "*" then .[:-1] | map(tonumber) | reduce .[] as $item (1; . * $item)
            else error("Unknown operation: " + .[-1])
            end
        ) |
        add |
        tostring
    )
' ${1:-example}


jq -Rrs '
    "Part 2: " +
    (
        gsub("^\n+|\n$"; "") |
        split("\n") |
        [
            .[:-1] |
            map(split("")) |
            transpose |
            map(join("")) |
            map(gsub(" +"; "")) |
            map(if . == "" then "\n" else . end) |
            join(" ") |
            split("\n") |
            map(gsub("^\\s+|\\s+$"; "")) |
            map(split(" ")) |
            map(map(tonumber))
        ] + [
            .[-1] |
            gsub(" +"; "") |
            gsub("^\\s+|\\s+$"; "") |
            split("")
        ] |
        transpose |
        map(
            if .[-1] == "+" then .[0] | add
            elif .[-1] == "*" then .[0] | reduce .[] as $item (1; . * $item)
            else error("Unknown operation: " + .[-1])
            end
        ) |
        add |
        tostring
    )' ${1:-example}