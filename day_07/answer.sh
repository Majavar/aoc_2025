#!/usr/bin/env bash

declare -A previous=()
declare count=0

while IFS= read -r line; do
    declare -A current=()
    if (( ${#previous[@]} )); then
        for i in "${!previous[@]}"; do
            if [[ "${line:i:1}" == "^" ]]; then
                    count=$(( count + 1 ))
                    if [[ -v current[$(( i - 1 ))] ]]; then
                        current[$(( i - 1 ))]=$(( current[$(( i - 1 ))] + previous[$i] ))
                    else
                        current[$(( i - 1 ))]=${previous[$i]}
                    fi

                    if [[ -v current[$(( i + 1 ))] ]]; then
                        current[$(( i + 1 ))]=$(( current[$(( i + 1 ))] + previous[$i] ))
                    else
                        current[$(( i + 1 ))]=${previous[$i]}
                    fi

            elif [[ -v current[$i] ]]; then
                current[$i]=$(( current[$i] + previous[$i] ))
            else
                current[$i]=${previous[$i]}
            fi
        done
    else
        for i in $(seq 0 $((${#line} - 1))); do
            if [[ "${line:i:1}" == "S" ]]; then
                current[$i]=1
            fi
        done
    fi

    # How to swap arrays without copy ?
    declare -A previous=()
    for key in "${!current[@]}"; do
        previous[$key]=${current[$key]}
    done

done < ${1:-example}

total=0
for key in "${!previous[@]}"; do
    total=$(( total + previous[$key] ))
done

echo Part 1: ${count}
echo Part 2: ${total}