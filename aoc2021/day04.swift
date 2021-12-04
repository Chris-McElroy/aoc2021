//
//  day04.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d4() {
	let input = inputWords([",", " "])
	let array = input[0].map { Int($0)! }
	var boards: [[Int]] = [[]]

	for line in input.dropFirst(2) {
		if line == [] {
			boards.append([])
		} else {
			boards[boards.count - 1].append(contentsOf: line.map { Int($0)! })
		}
	}

	var hits: [Set<Int>] = boards.map {_ in [] }
	var wins: Set<Int> = []

	for n in array {
		for (j, board) in boards.enumerated() where !wins.contains(j) {
			guard let i = board.firstIndex(of: n) else { continue }
			hits[j].insert(i)
			let worksV = (0..<5).count { hits[j].contains(5*$0 + (i % 5)) } == 5
			let worksH = (0..<5).count { hits[j].contains(5*(i/5) + $0) } == 5
			if worksH || worksV {
				wins.insert(j)
				if wins.count == 1 || wins.count == boards.count {
					print((board.sum() - hits[j].sum{ board[$0] }) * n)
				}
			}
		}
	}
}

// 16716
// 4880
