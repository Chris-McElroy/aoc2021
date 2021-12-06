//
//  day06.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d6() {
	let fishes = inputInts(",")
	
	var fishD: [Int: Int] = [:]
	for fish in fishes {
		fishD[fish, default: 0] += 1
	}
	
	for g in 0..<256 {
		print(g)
		var newFishD: [Int: Int] = [:]
		newFishD[6] = fishD[0]
		newFishD[8] = fishD[0]
		for l in 1..<9 {
			newFishD[l-1, default: 0] += fishD[l] ?? 0
		}
		fishD = newFishD
		
		if g == 80 { print(fishD.values.sum()) }
	}
	
	print(fishD.values.sum())
}
