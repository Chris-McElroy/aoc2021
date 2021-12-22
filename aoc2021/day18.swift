//
//  day18.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d18() {
	let input = inputStrings()
	var nums: [(Any, Any)] = []
	
	func readLine(s: String) -> (Any, Any) {
		var depth = 0
		var inner: String = ""
		var left: Any? = nil
		var right: Any? = nil
		for (_, c) in s.dropFirst().dropLast().enumerated() {
			if depth > 0 {
				inner.append(c)
			}
			if let n = Int(String(c)) {
				if depth == 0 {
					if left == nil {
						left = n
					} else {
						right = n
					}
				}
			} else {
				if c == "[" {
					if depth == 0 {
						inner = "["
					}
					depth += 1
				} else if c == "]" {
					if depth == 1 {
						if left == nil {
							left = readLine(s: inner)
						} else {
							right = readLine(s: inner)
						}
					}
					depth -= 1
				} else {
					// c is comma
				}
			}
		}
		
		return (left!, right!)
	}
	
	for line in input {
		nums.append(readLine(s: line))
	}
	
	func magnitude(of a: (Any, Any)) -> Int {
		var mag = 0
		if let v = a.0 as? Int {
			mag += 3 * v
		} else {
			mag += 3 * magnitude(of: a.0 as! (Any, Any))
		}
		if let v = a.1 as? Int {
			mag += 2 * v
		} else {
			mag += 2 * magnitude(of: a.1 as! (Any, Any))
		}
		return mag
	}
	
	func needExplode(_ a: (Any, Any), depth: Int = 0) -> Bool {
		if depth == 4 { return true }
		
		if let p = a.0 as? (Any, Any) {
			if needExplode(p, depth: depth + 1) { return true }
		}
		
		if let p = a.1 as? (Any, Any) {
			if needExplode(p, depth: depth + 1) { return true }
		}
		
		return false
	}
	
	func needSplit(_ a: (Any, Any)) -> Bool {
		if let p = a.0 as? (Any, Any) {
			if needSplit(p) { return true }
		} else {
			if a.0 as! Int > 9 { return true }
		}
		
		if let p = a.1 as? (Any, Any) {
			if needSplit(p) { return true }
		} else {
			if a.1 as! Int > 9 { return true }
		}
		
		return false
	}
	
	func propLeft(_ a: (Any, Any), v: Int) -> (Any, Any) {
		var res: (Any, Any) = a
		if let left = res.0 as? (Any, Any) {
			res.0 = propLeft(left, v: v)
		} else {
			res.0 = res.0 as! Int + v
		}
		return res
	}
	
	func propRight(_ a: (Any, Any), v: Int) -> (Any, Any) {
		var res: (Any, Any) = a
		if let right = res.1 as? (Any, Any) {
			res.1 = propRight(right, v: v)
		} else {
			res.1 = res.1 as! Int + v
		}
		return res
	}
	
	func explode(_ a: (Any, Any), depth: Int = 0) -> (Int, (Any, Any), Int, Bool) {
		var exploded = false
		var res: (Any, Any) = a
		var lefta = 0
		var righta = 0
		var rightai = 0
		var leftai = 0
		if let left = res.0 as? (Any, Any) {
			if depth == 3 {
				lefta = left.0 as! Int
				res.0 = 0
				rightai = left.1 as! Int
				exploded = true
			} else {
				let newLeft = explode(left, depth: depth + 1)
				res.0 = newLeft.1
				lefta = newLeft.0
				rightai = newLeft.2
				exploded = newLeft.3
			}
		}
		if let right = a.1 as? (Any, Any), !exploded {
			if depth == 3 {
				righta = right.1 as! Int
				res.1 = 0
				leftai = right.0 as! Int
				exploded = true
			} else {
				let newLeft = explode(right, depth: depth + 1)
				res.1 = newLeft.1
				righta = newLeft.2
				leftai = newLeft.0
				exploded = newLeft.3
			}
		}
		if leftai != 0 {
			if let left = res.0 as? (Any, Any) {
				res.0 = propRight(left, v: leftai)
			} else {
				res.0 = res.0 as! Int + leftai
			}
		}
		if rightai != 0 {
			if let right = res.1 as? (Any, Any) {
				res.1 = propLeft(right, v: rightai)
			} else {
				res.1 = res.1 as! Int + rightai
			}
		}
		return (lefta, res, righta, exploded)
	}
	
	func split(_ a: (Any, Any)) -> ((Any, Any), Bool) {
		var splitted = false
		var res = a
		if let p = a.0 as? (Any, Any) {
			let newSplit = split(p)
			res.0 = newSplit.0
			splitted = newSplit.1
		} else if let v = a.0 as? Int {
			if v > 9 {
				res.0 = (v/2, (v + 1)/2)
				splitted = true
			}
		}
		
		if let p = a.1 as? (Any, Any), !splitted {
			let newSplit = split(p)
			res.1 = newSplit.0
			splitted = newSplit.1
		} else if let v = a.1 as? Int, !splitted {
			if v > 9 {
				res.1 = (v/2, (v + 1)/2)
				splitted = true
			}
		}
		
		return (res, splitted)
	}
	
	func reduce(_ a: (Any, Any)) -> (Any, Any) {
		var res = a
		while needExplode(res) || needSplit(res) {
			while needExplode(res) {
				res = explode(res).1
//				print(res)
			}
			if needSplit(res) {
				res = split(res).0
//				print(res)
			}
		}
		return res
	}
	
	var cur = reduce(nums.first!)
	for num in nums.dropFirst() {
		cur = reduce((cur, num))
		
	}
	
	
	print(magnitude(of: cur))
	
	let pairs = nums.combinationsWithoutReplacement(length: 2).flatMap { [reduce(($0[0], $0[1])), reduce(($0[1], $0[0]))] }
	
	print(pairs.map { magnitude(of: $0) }.max()!)
}
// 111017 too high

// 3978 too low


// 13189 too high
// 12696
