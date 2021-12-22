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
	var p1: [State: Int] = [State(p: 7, s: 0): 1]
	var p2: [State: Int] = [State(p: 1, s: 0): 1]
	var wins: Int = 0
	var losses: Int = 0
	
	var turns = 1
	
	func doTurn(turn: Int) {
		var p = turn == 1 ? p1 : p2
		
		for _ in 0..<3 {
			var newP: [State: Int] = [:]
			for (s, n) in p {
				newP[State(p: s.p + 1, s: s.s), default: 0] += n
				newP[State(p: s.p + 2, s: s.s), default: 0] += n
				newP[State(p: s.p + 3, s: s.s), default: 0] += n
			}
			p = newP
		}
		
		/*
		 so in x worlds p1 won in 3 turns
		 in y worlds p2 won in 8 turns
		 */
		
		var newP: [State: Int] = [:]
		for (s, n) in p {
			let newPos = ((s.p - 1) % 10) + 1
			let newSc = s.s + newPos
			if newSc > 20 {
				if turn == 1 {
					wins += n * p2.sum { $0.value }
				} else {
					losses += n * p1.sum { $0.value }
				}
			} else {
				newP[State(p: newPos, s: newSc), default: 0] += n
			}
		}
		p = newP
		
		if turn == 1 {
			p1 = p
		} else {
			p2 = p
		}
		
		turns += 1
	}
	
	while !p1.isEmpty || !p2.isEmpty {
		doTurn(turn: 1)
		doTurn(turn: 2)
	}
	
//	while s1 < 1000 && s2 < 1000 {
	//		for _ in 0..<3 {
	//			die += 1
	//			p1 += ((die - 1) % 100) + 1
	//		}
	//		p1 = ((p1 - 1) % 10) + 1
	//
	//		s1 += p1
	//		if s1 >= 1000 { print("breaking"); break }
	//
	//		for _ in 0..<3 {
	//			die += 1
	//			p2 += ((die - 1) % 100) + 1
	//		}
	//		p2 = ((p2 - 1) % 10) + 1
	//
	//		s2 += p2
	//	}
	
	print("done")
//	var wins = 0
//	var losses = 0
//	var w1t = p1Wins.sum { $0.value }
//	var w2t = p2Wins.sum { $0.value }
	
//	print(w1t, w2t, p1, p2)
//	for (t1, n1) in p1Wins {
//		for (t2, n2) in p2Wins {
//			if t1 < t2 {
//				wins += n1 * n2
//			} else {
//				losses += n1 * n2
//			}
//		}
//	}
	
	print(wins, losses, max(wins, losses))
}
// 694656


// 3604128451160024 wrong
