//
//  day17.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d17() {
	let x = 206...250
	let y = (-105)...(-57)
	
	var bestPeak = 0
	var count = 0
	
	for inx in 0..<500 {
		for iny in -500..<1000 {
			var cx = 0
			var cy = 0
			
			var vx = inx
			var vy = iny
			var peak = 0
			while cx < 251 && cy > -106 {
				cx += vx
				cy += vy
				peak = max(cy, peak)
				vx = max(0, vx - 1)
				vy -= 1
				if x.contains(cx) && y.contains(cy) {
					bestPeak = max(peak, bestPeak)
					count += 1
					break
				}
			}
		}
	}
	
	print(bestPeak)
	print(count)
}

// 5460
// 3618
