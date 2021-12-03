//
//  day03.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d3() {
	let nums = Set(inputStrings())
	let bits = nums.first!.count

	func mostCommon(set: Set<String>, i: Int) -> Character {
		let count = set.sum { ($0[i] == "1").int }
		return count*2 >= set.count ? "1" : "0"
	}

	let g = Int(String((0..<bits).map({ mostCommon(set: nums, i: $0) })), radix: 2)!
	let e = 1<<bits - 1 - g
	print(g*e)

	func sortBy(_ keepCom: Bool) -> Int {
		var rem = nums
		var bit = 0
		while rem.count > 1 {
			let com = mostCommon(set: rem, i: bit)
			rem = rem.filter { ($0[bit] == com) == keepCom }
			bit += 1
		}
		return Int(rem.first!, radix: 2)!
	}

	print(sortBy(true) * sortBy(false))
}

// 1071734
// 6124992
