//
//  day09.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d9() {
	let points = inputIntArray("")
	print(points.coordinated().sum { p, v in p.adjacents.compactMap { points[opt: $0] }.min()! > v ? v + 1 : 0 })
	
	var basinSizes: [Int] = []
	for low in points.coordinated().compactMap({ p, v in p.adjacents.compactMap { points[opt: $0] }.min()! > v ? p : nil }) {
		let basin = Set([low]).bfs(expandUsing: { head, found in
			head.adjacents.compactMap { !found.contains($0) && points[opt: $0] ?? 10 < 9 ? $0 : nil }
		})
		basinSizes.append(basin.count)
	}
	print(basinSizes.sorted().last(3).product())
}
