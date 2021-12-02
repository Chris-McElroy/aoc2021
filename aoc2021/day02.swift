//
//  day02.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d2() {
	let dirs = inputWords()
	
	var hor = 0
	var depth = 0
	
	for dir in dirs {
		switch dir[0] {
		case "forward":
			hor += Int(dir[1])!
		case "down":
			depth += Int(dir[1])!
		case "up":
			depth -= Int(dir[1])!
		default: break
		}
	}
	
	print(hor * depth)
	
	hor = 0
	depth = 0
	var aim = 0
	
	for dir in dirs {
		switch dir[0] {
		case "forward":
			hor += Int(dir[1])!
			depth += aim * Int(dir[1])!
		case "down":
			aim += Int(dir[1])!
		case "up":
			aim -= Int(dir[1])!
		default: break
		}
	}
	
	print(hor * depth)
}

// 1499229
// 1340836560
