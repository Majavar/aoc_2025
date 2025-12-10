use std::{
    cmp::{max, min},
    env::args,
    fs::read_to_string,
    iter::{once},

};

fn main() {
    let filename = args().nth(1).unwrap_or_else(|| "example".to_string());
    let positions = read_to_string(filename).unwrap().lines()
        .map(|line| line.split(',').map(|c| c.parse::<u64>().unwrap()).collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let mut best_area = 0;
    for i in 0..positions.len() {
        for j in (i + 1)..positions.len() {
            let width = positions[i][0].abs_diff(positions[j][0]) + 1;
            let height = positions[i][1].abs_diff(positions[j][1]) + 1;
            let area = width * height;
            best_area = max(best_area, area);
        }
    }
    println!("Part 1: {}", best_area);

    let edges = positions.windows(2).map(|w| {
        let x1 = min(w[0][0], w[1][0]);
        let x2 = max(w[0][0], w[1][0]);
        let y1 = min(w[0][1], w[1][1]);
        let y2 = max(w[0][1], w[1][1]);
        (x1, y1, x2, y2)
    }).chain(once( {
        let x1 = min(positions.first().unwrap()[0], positions.last().unwrap()[0]);
        let x2 = max(positions.first().unwrap()[0], positions.last().unwrap()[0]);
        let y1 = min(positions.first().unwrap()[1], positions.last().unwrap()[1]);
        let y2 = max(positions.first().unwrap()[1], positions.last().unwrap()[1]);
        (x1, y1, x2, y2)
    })).collect::<Vec<_>>();

    let mut best_area = 0;
    for i in 0..positions.len() {
        for j in (i + 1)..positions.len() {
            let minx = min(positions[i][0], positions[j][0]) + 1;
            let miny = min(positions[i][1], positions[j][1]) + 1;
            let maxx = max(positions[i][0], positions[j][0]) - 1;
            let maxy = max(positions[i][1], positions[j][1]) - 1;

            if [(minx, miny, maxx, miny),
                (minx, maxy, maxx, maxy),
                (minx, miny, minx, maxy),
                (maxx, miny, maxx, maxy)
            ].iter().any(|(x1, y1, x2, y2)| {
                edges.iter().any(|(ex1, ey1, ex2, ey2)| {
                    (*x1 == *x2 && *ey1 == *ey2 && *x1 >= *ex1 && *x1 <= *ex2 && min(*y1, *y2) <= *ey1 && max(*y1, *y2) >= *ey1) ||
                    (*y1 == *y2 && *ex1 == *ex2 && *y1 >= *ey1 && *y1 <= *ey2 && min(*x1, *x2) <= *ex1 && max(*x1, *x2) >= *ex1)
                })
            }) {
                continue;
            }

            let width = positions[i][0].abs_diff(positions[j][0]) + 1;
            let height = positions[i][1].abs_diff(positions[j][1]) + 1;
            let area = width * height;
            best_area = max(best_area, area);
        }
    }
    println!("Part 2: {}", best_area);
}
