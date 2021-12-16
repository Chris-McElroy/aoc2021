//
//  day14.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d14() {
	let cur = inputStrings()[0]
	let rules = inputWords(" -> ").dropFirst(2)
	var pairs: [String: Int] = [:]
	
	for (i, c) in cur.dropLast().enumerated() {
		pairs[String(c) + String(cur[i + 1]), default: 0] += 1
	}
	
	func printDiff() {
		var counts: [Character: Int] = [:]
		for pair in pairs {
			counts[pair.key[0], default: 0] += pair.value
			counts[pair.key[1], default: 0] += pair.value
		}
		print((counts.max(by: { $0.value < $1.value })!.value - counts.min(by: { $0.value < $1.value })!.value)/2)
	}
	
	for s in 1...40 {
		var newPairs: [String: Int] = [:]
		for (pair, n) in pairs {
			for rule in rules {
				if rule[0] == pair {
					newPairs[String(pair[0]) + rule[1], default: 0] += n
					newPairs[rule[1] + String(pair[1]), default: 0] += n
					break
				}
			}
		}
		pairs = newPairs
		
		if s == 10 {
			printDiff()
		}
	}
	
	printDiff()
}

// 2112
// 3243771149914
