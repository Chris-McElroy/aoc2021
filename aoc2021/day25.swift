//
//  day25.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d25() {
	var sf = inputWords("")
	let height = sf.count
	let width = sf[0].count
//	print(width, height)
	var moved = 0
	var steps = 0
	
	func stepEast() -> [[String]] {
		var newS: [[String]] = make2DArray(repeating: ".", count1: height, count2: width)
		for (p, s) in sf.coordinated() {
			if s == "." { continue }
			if s == "v" { newS[p] = s; continue }
			let newP = p.x == width - 1 ? C2(0, p.y) : C2(p.x + 1, p.y)
			if sf[newP] == "." {
				moved += 1
				newS[newP] = ">"
			} else {
				newS[p] = s
			}
		}
		return newS
	}
	
	func stepDown() -> [[String]] {
		var newS: [[String]] = make2DArray(repeating: ".", count1: height, count2: width)
		for (p, s) in sf.coordinated() {
			if s == "." { continue }
			if s == ">" { newS[p] = s; continue }
			let newP = p.y == height - 1 ? C2(p.x, 0) : C2(p.x, p.y + 1)
			if sf[newP] == "." {
				moved += 1
				newS[newP] = "v"
			} else {
				newS[p] = s
			}
		}
		return newS
	}
	
	repeat {
//		print(steps)
		moved = 0
		sf = stepEast()
		sf = stepDown()
		steps += 1
	} while moved > 0 && steps < 10000
	
	print(steps)
}
