//
//  day05.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d5() {
	let info = inputSomeInts(words: [0, 1, 2, 3], [",", " -> "])
	var points: [C2: Int] = [:]
	
	for i in 0..<info[0].count {
		var x = info[0][i]
		var y = info[1][i]
		var dx = 0
		var dy = 0
		if info[0][i] < info[2][i] { dx = 1 }
		else if info[0][i] > info[2][i] { dx = -1 }
		if info[1][i] < info[3][i] { dy = 1 }
		else if info[1][i] > info[3][i] { dy = -1 }
		
//		if dx * dy != 0 { continue }
		
		while x != info[2][i] || y != info[3][i] {
			points[C2(x, y), default: 0] += 1
				x += dx
				y += dy
		}
		
			points[C2(x, y), default: 0] += 1
	}
	
	print(points.count { $0.value > 1 })
}

// 6362 wrong
