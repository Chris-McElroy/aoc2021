//
//  day16.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d16() {
	let binary: [Int] = inputStrings()[0].hexToBinaryArray()
	var i = 0
	var versionSum = 0
	
	func toInt(_ s: ArraySlice<Int>) -> Int {
		Int(s.map({ String($0) }).joined(), radix: 2)!
	}
	
	func packageValue() -> Int {
		versionSum += toInt(binary[i, i + 3])
		let type = toInt(binary[i + 3, i + 6])
		i += 6
		
		if type == 4 {
			var v = 0
			while binary[i] == 1 {
				v = 16 * v + toInt(binary[i + 1, i + 5])
				i += 5
			}
			v = 16 * v + toInt(binary[i + 1, i + 5])
			i += 5
			return v
		} else {
			var subVs: [Int] = []
			
			if binary[i] == 0 {
				let end = i + 16 + toInt(binary[i + 1, i + 16])
				i += 16
				while i < end {
					subVs.append(packageValue())
				}
			} else {
				let count = toInt(binary[i + 1, i + 12])
				i += 12
				while subVs.count < count {
					subVs.append(packageValue())
				}
			}
			
			switch type {
			case 0: return subVs.sum()
			case 1: return subVs.product()
			case 2: return subVs.min()!
			case 3: return subVs.max()!
			case 5: return (subVs[0] > subVs[1]).int
			case 6: return (subVs[0] < subVs[1]).int
			case 7: return (subVs[0] == subVs[1]).int
			default: return 0
			}
		}
	}

	let v = packageValue()
	print(versionSum)
	print(v)
}

// 906
// 819324480368
