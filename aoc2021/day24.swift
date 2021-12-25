//
//  day24.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d24() {
	let program = inputWords()
	var i = 0 // line
	var input: List<Int> = []
	var lastInput: [Int] = Array(repeating: 9, count: 8)
	var justIn: Int = 0
	var reg: [Int] = [0,0,0,0]
	var inputI = 0
	
	func getR(_ r: String) -> Int {
		return ["w": 0, "x": 1, "y": 2, "z": 3][r]!
	}
	
	func getV(_ v: String) -> Int {
		if let r = ["w": 0, "x": 1, "y": 2, "z": 3][v] {
			return reg[r]
		} else {
			return Int(v)!
		}
	}
	
	func runOne() -> Bool {
		let line = program[i]
		
		switch line[0] {
		case "inp":
			if i == 0 {
				justIn = justIn * 10 + 2
				reg[getR(line[1])] = 2
			} else if i == 36 {
				justIn = justIn * 10 + 9
				reg[getR(line[1])] = 9
			} else if program[i + 5][2][0] == "-" {
				let ans = (reg[3] % 26) + Int(program[i + 5][2])!
//				print("solving", i, reg, reg[3] % 26, program[i + 5], ans)
				if ans > 0 && ans < 10 {
					justIn = justIn * 10 + ans
					reg[getR(line[1])] = ans
				} else {
					return false
				}
			} else {
				inputI += 1
				justIn = justIn * 10 + input.first!
				reg[getR(line[1])] = input.popFirst()!
			}
		case "add":
			reg[getR(line[1])] += getV(line[2])
		case "mul":
			reg[getR(line[1])] *= getV(line[2])
		case "div":
			reg[getR(line[1])] /= getV(line[2])
		case "mod":
			reg[getR(line[1])] %= getV(line[2])
		case "eql":
			reg[getR(line[1])] = (reg[getR(line[1])] == getV(line[2])).int
		default: break
		}
		i += 1
		return true
	}
	
	func runAll() -> Bool {
		justIn = 0
		inputI = 0
		i = 0
		reg = [0,0,0,0]
		while i < program.count {
			if !runOne() {
				return false
			}
//			if i % 18 == 0 {
//				if reg[3] != 0 {
//					print(reg[3])
////					if i == 18*10 { return 0 }
////					return count
//				} else {
//					print("got one!")
//					count += 1
//				}
//			}
		}
		
		print(reg[3])
		return reg[3] == 0
	}
	
	var best = 0
	for n in stride(from: 11111, through: 99999, by: 1) {
		if String(n).contains("0") { continue }
	
		input = []
		var subN = n
		while subN > 0 {
			input.prepend(subN % 10)
			subN /= 10
		}
//		if n == 9713111 { print(input) }
		if runAll() { print("gottem", justIn); best = justIn; break }
//		let lastlastIn = lastInput
//		if inputI < 6 {
//			for j in (inputI + 1)..<7 {
//				lastInput[j] = 9
//			}
//		}
//		lastInput[inputI] -= 1
//		while lastInput[inputI] == 0 {
//			lastInput[inputI] = 9
//			inputI -= 1
//			lastInput[inputI] -= 1
//		}
//		print(inputI, lastlastIn, lastInput)
	}
		
		
	/*
	 z0 = w0 + 8
	 z1 = z0*26 + w1 + 11
	 z2 = z1*26 + w2 + 2
	 z3 = z1 + ((w2 - 8) != w3) ? (z1*25 + w3 + 11) : 0
	 z4 = z3*26 + w4 + 1
	 z5 = z3 + (w4 - 2 != w5) ? (z3*25 + w5 + 5) : 0
	 z6 = z5/26 + ([false || w3 - 3 || w1 - 3] != w6) ? (z5/26*25 + w6 + 10) : 0
	 z7 = z6*26 + w7 + 6
	 z8 = z7*26 + w8 + 1
	 z9 = z8*26 + w9 + 11
	 z10= z8/26 + (w9 + 5 != w10) ? (z8/26*25 + w10 + 9) : 0
	 z11= z10/26 + ([w10 + 3 || w7] != w11) ? (z10/26*25 + w11 + 14) : 0
	 z12= z11/26 + ([false || w10 + 7 || w7 + 4] != w12) (z11/26*25 + w12 + 11) : 0
	 z13= z12/26 + ([w12 + 2 || false || w10 || w7 - 3] != w13) ? (z12/26*25 + w13 + 2) : 0
	
	 */
	
	
	
//	var working = 0
//	var last = 0
//	input = List(lastInput)
//	var runError = runAll()
//
//	while runError != 14 {
//		if runError > last {
//			last = runError
////			print(last)
//		} else if runError < last {
//			print("WHAT")
//		}
////		var j =
//		lastInput[runError] += 1
//		if lastInput[runError] == 9 { break }
////		repeat {
////			if lastInput[j] == 0 { lastInput[j] = 9 }
////			lastInput[j] = (lastInput[j] - 1) % 9 + 1
////			if lastInput[j] == 9 && j > 0 { lastInput[j-1] -= 1 }
////			j -= 1
////		} while j >= 0 && lastInput[j] == 0
//
//		input = List(lastInput)
//		runError = runAll()
//	}
//
	print("worked!", best)
}
// (25 * ((z0 % 26 - 9) != w) + 1) * z0/26 = -((z0 % 26 - 9 != w) * (w + 2))

// 97228819858933 too low
