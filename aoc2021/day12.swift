//
//  day12.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//

import Foundation

func d12() {
	let cons = inputWords("-")
	let allPaths = Set([["start"]]).bfs(expandUsing: { path, _ in
		if path.last == "end" { return [] }
		var nextPaths: [[String]] = []
		let max = path.any { cave in cave != "start" && cave[0].isLowercase && path.count { $0 == cave } > 1 } ? 1 : 2
		for con in cons {
			if con[0] == path.last {
				if con[1] != "start" && (con[1][0].isUppercase || (path.count { $0 == con[1] } < max)) {
					nextPaths.append(path + [con[1]])
				}
			} else if con[1] == path.last {
				if con[0] != "start" && (con[0][0].isUppercase || (path.count { $0 == con[0] } < max)) {
					nextPaths.append(path + [con[0]])
				}
			}
		}
		return nextPaths
	})
	print(allPaths.count { $0.last == "end" })
}
