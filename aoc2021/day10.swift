//
//  day10.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d10() {
	let lines = inputStrings()
	var pon = 0
	var work: [Int] = []
	
	for line in lines {
		var open: [Character] = []
		var points = 0
		var workin = true
		for c in line {
			if c == open.last {
				open.removeLast()
			} else if ")}]>".contains(c) {
				pon += [")": 3, "]": 57, "}": 1197, ">": 25137][c]!
				workin = false
				break
			} else {
				open.append(["(": ")", "[": "]", "{": "}", "<": ">"][c]!)
			}
		}
		if workin {
			for c in open.reversed() {
				points *= 5
				points += [")": 1, "]": 2, "}": 3, ">": 4][c]!
			}
			
			
			work.append(points)
		}
	}
	
	print(pon)
	print(work.sorted()[work.count/2])
}
// 3999723043 wrong
