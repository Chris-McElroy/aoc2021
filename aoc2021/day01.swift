//
//  day01.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d1() {
	let input = inputInts()
	let max = input.max()!
	let prev = List([max, max, max])
	var a1 = 0
	var a2 = 0
	
	for n in inputInts() {
		a1 += (n > prev.last!).int
		let oldSum = prev.sum()
		prev.removeFirst()
		prev.append(n)
		a2 += (prev.sum() > oldSum).int
	}
	print(a1, a2)
}
