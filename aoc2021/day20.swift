//
//  day20.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d20() {
	let alg = inputStrings()[0]
	
	let imageIn = Array(inputWords("").dropFirst(2))
	var image: [C2: Bool] = Dictionary(Array(inputWords("").dropFirst(2)).coordinated().map { (p, c) in [p: c == "#"] })
	
	for (p, c) in imageIn.coordinated() {
		image[p] = c == "#"
	}
	
	for _ in 0..<50 {
		var newImage: [C2: Bool] = [:]
		for y in -120..<220 {
			for x in -120..<220 {
				var n = 0
				let base = C2(x, y)
				for neighbor in base.neighborsWithSelf {
					n *= 2
					n += (image[neighbor, default: false]).int
				}
				newImage[base] = alg[n] == "#"
			}
		}
		image = newImage
	}
	
	for p in image.keys {
		if p.x > 155 || p.x < -55 || p.y > 155 || p.y < -55 {
			image[p] = false
		}
	}
	
	print(image.count { $0.value })
}

// 16875
