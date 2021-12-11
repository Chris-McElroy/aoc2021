//
//  day08.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d8() {
	let wires = inputWords()
	var sum = 0
	var codes: [[String]] = []
	var displays: [[String]] = []
	
	for wire in wires {
		codes.append([])
		displays.append([])
		var go = false
		for word in wire {
			if go {
				if [2,4,7,3].contains(word.count) {
					sum += 1
				}
				displays[displays.count - 1].append(word)
			} else {
				if word == "|" {
					go = true
				} else {
					codes[codes.count - 1].append(word)
				}
			}
		}
	}
	print(sum)
	
	var sum2 = 0
	for (i, var code) in codes.map({ $0.map({ Set($0) }) }).enumerated() {
		code.sort(by: { $0.count < $1.count })
		var mapping: [Set<Character>] = Array(repeating: [], count: 10)
		mapping[1] = code.removeFirst()
		mapping[7] = code.removeFirst()
		mapping[4] = code.removeFirst()
		mapping[8] = code.removeLast()
		mapping[6] = code.last(where: { !mapping[1].subtracting($0).isEmpty })!
		mapping[5] = code.first(where: { $0.all { mapping[6].contains($0) } })!
		mapping[9] = Set(mapping[5]).union(mapping[1])
		mapping[0] = code.last(where: { $0 != mapping[6] && $0 != mapping[9] })!
		mapping[3] = code.first(where: { mapping[1].subtracting($0).isEmpty })!
		mapping[2] = code.first(where: { $0 != mapping[5] && $0 != mapping[3] })!
		var n = 0
		
		for digit in displays[i] {
			n = n*10 + mapping.firstIndex(where: { Set(digit) == $0 })!
		}
		
		sum2 += n
	}
	print(sum2)
}

// 514
// 1012272
