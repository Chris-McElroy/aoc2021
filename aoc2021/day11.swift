//
//  day11.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d11() {
	var ints = inputIntArray("")
	var flashes = 0
	
	for s in 1...10000 {
		for p in ints.allPoints() {
			ints[p] += 1
		}
		
		var toFlash: [C2] = ints.allPoints().filter { ints[$0] == 10 }
		var wasFlashed: [C2] = []
		while let p = toFlash.popLast() {
			wasFlashed.append(p)
			for n in p.neighbors where ints.inbound(n) {
				ints[n] += 1
				if ints[n] == 10 {
					toFlash.append(n)
				}
			}
		}
		
		for p in wasFlashed { ints[p] = 0 }
		
		if s <= 100 { flashes += wasFlashed.count }
		if s == 100 { print(flashes) }
		
		if wasFlashed.count == 100 {
			print(s)
			break
		}
	}
}
