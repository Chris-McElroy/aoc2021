//
//  day01.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d1() {
	let depths = inputInts()
	print((1..<depths.count).count { depths[$0] > depths[$0 - 1] })
	print((3..<depths.count).count { depths[$0] > depths[$0 - 3] })
}

// 1754
// 1789
