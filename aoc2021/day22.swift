//
//  day22.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d22() {
	let onoff = inputWords().map { $0.first! == "on" }
	let intlist = inputIntArray(["on x=", "off x=", "..", ",y=",",z="])
	let bounds = intlist.map { line in ClosedBound3(line[0]...line[1], line[2]...line[3], line[4]...line[5]) }
	
	func numOn(region: ClosedBound3, before: Int) -> Int {
		var num = 0
		for (i, bound) in bounds.first(before).enumerated() {
			guard let overlap = region.overlap(with: bound) else { continue }
			if onoff[i] { num += overlap.count }
			num -= numOn(region: overlap, before: i)
		}
		return num
	}
	
	print(numOn(region: ClosedBound3(), before: bounds.count))
}
