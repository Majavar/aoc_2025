#include <algorithm>
#include <array>
#include <cmath>
#include <iostream>
#include <fstream>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

#ifndef PART1_COUNT
#define PART1_COUNT 1000
#endif

int main(int argc, char** argv) {
    std::string input = argc == 2 ? argv[1] : "example";
    std::vector<std::array<int, 3>> positions;

    // read positions
    std::ifstream infile(input);
    for (std::string line; std::getline(infile, line);) {
        std::stringstream ss(line);
        std::array<int, 3> row;

        for (int i = 0; i < 3; ++i) {
            std::string value;
            std::getline(ss, value, ',');
            row[i] = std::stoi(value);
        }

        positions.push_back(row);
    }

    // calculate distances
    std::vector<std::pair<std::array<int, 2>, double>> distances;
    for (int i = 0; i < positions.size(); ++i) {
        for (int j = i + 1; j < positions.size(); ++j) {
            double dist = std::sqrt(
                std::pow(positions[i][0] - positions[j][0], 2) +
                std::pow(positions[i][1] - positions[j][1], 2) +
                std::pow(positions[i][2] - positions[j][2], 2)
            );
            distances.push_back({{i, j}, dist});
        }
    }

    // sort distances
    std::sort(distances.begin(), distances.end(),
        [](const auto& a, const auto& b) {
            return a.second < b.second;
        }
    );

    size_t count = 0;
    // compute groups
    std::vector<std::pair<std::optional<int>, std::vector<size_t>>> groups;
    for (size_t i = 0; i < positions.size(); ++i) {
        groups.push_back({std::nullopt, {i}});
    }
    for (const auto& [pair, _]: distances) {
        int left = pair[0], right = pair[1];
        int left_group = groups[left].first.value_or(groups[left].second[0]);
        int right_group = groups[right].first.value_or(groups[right].second[0]);

        count++;
        if (count == PART1_COUNT + 1) {
            std::vector<size_t> group_sizes;
            for (const auto& [gid, g]: groups) {
                if (!gid) {
                    group_sizes.push_back(g.size());
                }
            }
            std::sort(group_sizes.begin(), group_sizes.end(),
                std::greater<size_t>());
            std::cout << "Part 1: " << group_sizes[0] * group_sizes[1] * group_sizes[2] << std::endl;
        }

        if (left_group == right_group) {
            continue;
        }

        groups[left_group].second.insert(
            groups[left_group].second.end(),
            groups[right_group].second.begin(),
            groups[right_group].second.end()
        );
        for (const auto& index: groups[right_group].second) {
            groups[index].first = left_group;
        }
        groups[right_group].second.clear();

        if (groups[left_group].second.size() == positions.size()) {
            std::cout << "Part 2: " << positions[left][0] * positions[right][0] << std::endl;
            break;
        }
    }

    return 0;
}