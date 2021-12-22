//
//  day19.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d19() {
	var scanners: [[C3]] = []
	var positions: [Int: (C3, Int)] = [0: (C3(0,0,0), 0)]
	var checked: [Int: Set<Int>] = [:]
	
	for line in inputStrings() {
		if line.contains("scanner") {
			scanners.append([])
		} else if line != "" {
			let parts = line.split(separator: ",").map { Int($0)! }
			scanners[scanners.count - 1].append(C3(parts[0], parts[1], parts[2]))
		}
	}
	
	
	let allScanners: [[[C3]]] = scanners.map { bs in
		var newSet: [[C3]] = Array(repeating: [], count: 64)
		for b in bs {
			for p in 0..<64 {
				newSet[p].append(b.redirect(to: p))
			}
		}
		return newSet
	}
	
	var matched = 0
	func getMatch(_ i: Int, _ j: Int, _ p1: Int, _ p2: Int) -> C3? {
		var matches: [C3: Int] = [:]
		for b1 in allScanners[i][p1] {
			for b2 in allScanners[j][p2] {
				matches[b2 - b1, default: 0] += 1
			}
		}
		
		let match = matches.first(where: { $0.value >= 12 })
		if let new = match?.value {
			matched += new
		}
		return match?.key
	}
	
	var lastFound: Int = 0
	while positions.keys.count != lastFound {
		lastFound = positions.keys.count
//		print(positions.count)
		for (i, p) in positions {
			let p1 = p.1
			for j in 0..<scanners.count where !positions.keys.contains(j) && i != j && !checked[i, default: []].contains(j) {
				checked[i, default: []].insert(j)
				checked[j, default: []].insert(i)
				for p2 in 0..<64 {
					if let newPos = getMatch(i, j, p1, p2) {
						positions[j] = (newPos + p.0, p2)
						print("got match!")
						break
					}
				}
			}
		}
		
//		if positions.count == 1 && positions.keys.first! < scanners.count - 1 {
//			positions = [positions.keys.first! + 1: C3(0,0,0)]
//		}
	}

	var area: Set<C3> = []
	print(scanners.count, positions.count)
	for (i, p) in positions {
//		print(i, p.0, p.1)
		for b in allScanners[i][p.1] {
			area.insert(b - p.0)
		}
	}
	
	print("got all", scanners.sum { $0.count } - matched, area.count)
	
	var best = 0
	for (i, p1) in positions {
		for (j, p2) in positions where i != j {
			let new = (p1.0 - p2.0).manhattanDistance()
			best = max(new, best)
		}
	}
	
	print(best)
}

// 315
// 13192

// TODO actually implement 3d and 2d rotations better
// i want to be able to say give me the array of all the rotations of p
// and i want to say give me rotation n of p
