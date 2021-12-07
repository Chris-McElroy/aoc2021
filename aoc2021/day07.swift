//
//  day07.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d7() {
	let crabs = inputInts(",")
	print(((-1000..<1000).map{ a in crabs.sum { abs($0 - a) } }).min()!)
	print(((-1000..<1000).map{ a in crabs.sum { abs($0 - a) * (abs($0 - a) + 1)/2 } }).min()!)
}
// i got fucking 107 on part two only cuz i got held up on part 1 cuz i kept thinking my solution was correct instead of just doing all possible averages
