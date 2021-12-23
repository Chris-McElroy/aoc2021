//
//  day21.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d21() {
	struct State: Hashable {
		let p: Int
		let s: Int
	}
	var p: [[State: Int]] = inputWords(": ").map { [State(p: Int($0[1])!, s: 0): 1] }
	var wins: [Int] = [0, 0]
	
	func doTurn(turn: Int) {
		for _ in 0..<3 {
			var newP: [State: Int] = [:]
			for (s, n) in p[turn] {
				newP[State(p: s.p + 1, s: s.s), default: 0] += n
				newP[State(p: s.p + 2, s: s.s), default: 0] += n
				newP[State(p: s.p + 3, s: s.s), default: 0] += n
			}
			p[turn] = newP
		}
		
		var newP: [State: Int] = [:]
		for (s, n) in p[turn] {
			let newPos = ((s.p - 1) % 10) + 1
			let newSc = s.s + newPos
			if newSc > 20 {
				wins[turn] += n * p[turn^1].sum { $0.value }
			} else {
				newP[State(p: newPos, s: newSc), default: 0] += n
			}
		}
		p[turn] = newP
	}
	
	while p != [[:], [:]] {
		doTurn(turn: 0)
		doTurn(turn: 1)
	}
	
	print(wins.max()!)
}

// 694656
// 152587196649184
