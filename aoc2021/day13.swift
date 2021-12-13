//
//  day13.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d13() {
	var folds: [(Bool, Int)] = []
	inputWords("=").filter({ $0 != [] && $0[0][0] == "f" }).forEach {
		folds.append(($0[0].last == "x", Int($0[1])!))
	}
	
	var dots: Set<C2> = []
	inputIntArray(",").forEach { dots.insert(C2($0[0], $0[1])) }
	
	for (i, fold) in folds.enumerated() {
		if fold.0 {
			dots = Set(dots.map { C2($0.x > fold.1 ? fold.1*2 - $0.x : $0.x, $0.y) })
		} else {
			dots = Set(dots.map { C2($0.x, $0.y > fold.1 ? fold.1*2 - $0.y : $0.y) })
		}
		if i == 0 { print(dots.count) }
	}
	
	print2DArray(width: 40, height: 6, shouldPrint: { dots.contains($0) })
}
