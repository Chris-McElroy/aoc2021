//
//  day23.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d23() {
	let goals: [Character: Int] = [
		"A": 3,
		"B": 5,
		"C": 7,
		"D": 9
	]
	
	let spots: [C2: Character] = [
		C2(3,2): "A",
		C2(3,3): "D",
		C2(3,4): "D",
		C2(3,5): "D",
		C2(5,2): "C",
		C2(5,3): "C",
		C2(5,4): "B",
		C2(5,5): "D",
		C2(7,2): "B",
		C2(7,3): "B",
		C2(7,4): "A",
		C2(7,5): "B",
		C2(9,2): "A",
		C2(9,3): "A",
		C2(9,4): "C",
		C2(9,5): "C"
//		C2(1,1): nil,
//		C2(2,1): nil,
//		C2(4,1): nil,
//		C2(6,1): nil,
//		C2(8,1): nil,
//		C2(10,1): nil,
//		C2(11,1): nil
	]
	
//	let endGoal: [C2: Character] = [
//		C2(3,2): "A",
//		C2(3,3): "A",
//		C2(5,2): "B",
//		C2(5,3): "B",
//		C2(7,2): "C",
//		C2(7,3): "C",
//		C2(9,2): "D",
//		C2(9,3): "D"
//		C2(1,1): nil,
//		C2(2,1): nil,
//		C2(4,1): nil,
//		C2(6,1): nil,
//		C2(8,1): nil,
//		C2(10,1): nil,
//		C2(11,1): nil
//	]
	
	struct Path {
		let clears: Set<C2>
		let cost: Int
	}
	
	let area: [[C2]] = [
		[C2(1,1)],
		[C2(2,1)],
		[C2(3,2), C2(3,3), C2(3,4), C2(3,5)],
		[C2(4,1)],
		[C2(5,2), C2(5,3), C2(5,4), C2(5,5)],
		[C2(6,1)],
		[C2(7,2), C2(7,3), C2(7,4), C2(7,5)],
		[C2(8,1)],
		[C2(9,2), C2(9,3), C2(9,4), C2(9,5)],
		[C2(10,1)],
		[C2(11,1)]
	]
	
	var paths: [C2: [C2: Path]] = [:]
	
	for (i, column1) in area.enumerated() {
		for spot1 in column1 {
			for (j, column2) in area.enumerated() where i < j {
				for spot2 in column2 {
					if (spot1.y == 1) == (spot2.y == 1) { continue }
					var clears: Set<C2> = []
					for x in (i + 1)..<j {
						if x % 2 == 1 {
							clears.insert(area[x].first!)
						}
					}
					if spot1.y > 2 {
						for y in 2..<spot1.y {
							clears.insert(C2(spot1.x, y))
						}
					} else if spot2.y > 2 {
						for y in 2..<spot2.y {
							clears.insert(C2(spot2.x, y))
						}
					}
					let path = Path(clears: clears, cost: (spot1 - spot2).manhattanDistance())
					paths[spot1, default: [:]][spot2] = path
					paths[spot2, default: [:]][spot1] = path
				}
			}
		}
	}
	
	struct State: Hashable, CustomStringConvertible {
		let p: [C2: Character]
		let energy: Int
		
	
		var description: String {
			var s = ["#############","#...........#","###.#.#.#.###","  #.#.#.#.#","  #.#.#.#.#","  #.#.#.#.#","  #########"]
			for (p2, a) in p {
				s[p2.y][p2.x] = a
			}
			return s.joined(separator: "\n") + "\n" + String(energy)
		}
	}
	
	let costs: [Character: Int] = [
		"A": 1, "B": 10, "C": 100, "D": 1000
	]
	
	var bestEnergy = Int.max
	var furthest = 0
	
	let states: Set<State> = [State(p: spots, energy: 0)]
	
	states.bfsForwardOnly(expandUsing: { state in
		if state.energy > bestEnergy { return [] }
		
		var matches = 0
		for (p, a) in state.p {
			if p.x == goals[a] {
				matches += 1
			}
		}
		if matches == 16 {
			bestEnergy = min(bestEnergy, state.energy)
			furthest = matches
			return []
		} else if matches > furthest {
			furthest = matches
		} else if matches < furthest - 1 {
			// the 1 here may need to be 2 or 3 if 1 is too greedy
			return []
		}
		
		var nextStates: [State] = []
		
		for (p, a) in state.p {
			guard goals[a] != p.x || (p == C2(3, 2) && state.p[C2(3,3)] == "D") || (p == C2(5,4) && state.p[C2(5,5)] == "D") else { continue }
			for myPaths in paths[p]! {
				search: for (end, path) in Dictionary(dictionaryLiteral: myPaths) {
					if path.clears.any(where: { state.p[$0] != nil }) { continue }
					if state.p[end] != nil { continue }
					if end.y == 1 {
						var newP = state.p
						newP[p] = nil
						newP[end] = a
						nextStates.append(State(p: newP, energy: state.energy + path.cost*costs[a]!))
					} else {
						if goals[a] != end.x { continue }
						if end.y > 2 {
							for y in 2..<end.y {
								if state.p[C2(end.x, y)] != nil { continue search }
							}
						}
						if end.y < 5 {
							for y in (end.y + 1)...5 {
								if state.p[C2(end.x, y)] != a { continue search }
							}
						}
						var newP = state.p
						newP[p] = nil
						newP[end] = a
						nextStates.append(State(p: newP, energy: state.energy + path.cost*costs[a]!))
					}
				}
			}
		}
		
		return nextStates
	})
	
	print(bestEnergy)
}

// 50265
