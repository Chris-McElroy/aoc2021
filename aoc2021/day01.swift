//
//  day01.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d1() {
	let depths = inputInts()
	print((1..<depths.count).reduce(0) { $0 + (depths[$1] > depths[$1 - 1]).int })
	print((3..<depths.count).reduce(0) { $0 + (depths[$1] > depths[$1 - 3]).int })
}

// 1754
// 1789
