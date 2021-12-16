//
//  day15.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d15() {
	let area1 = inputIntArray("")
	var area2: [[Int]] = Array(repeating: [], count: area1.count * 5)
	
	for y in 0..<5 {
		for x in 0..<5 {
			for (i, line) in area1.enumerated() {
				area2[i + y*area1.count] += line.map { ((($0 - 1) + x + y) % 9) + 1  }
			}
		}
	}
	
	func findBestPath(area: [[Int]]) {
		var bestPositions: [C2: Int] = [C2(0,0): 0]
		var positions: [C2: Int] = [C2(0,0): 0]
		var best = Int.max
		let br = C2(area.count - 1, area[0].count - 1)
		
		while !positions.isEmpty {
			var newPositions: [C2: Int] = [:]
			for (p, v) in positions {
				for neig in p.adjacents {
					if neig == br {
						let res = v + area[neig]
						best = min(best, res)
					} else if let r = area[opt: neig], bestPositions[neig] ?? Int.max > r + v {
						newPositions[neig] = r + v
						bestPositions[neig] = r + v
					}
				}
			}
			positions = newPositions
		}
		
		print(best)
	}
	
	findBestPath(area: area1)
	findBestPath(area: area2)
}

// 435
// 2482
