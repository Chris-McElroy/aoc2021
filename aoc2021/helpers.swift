//
//  helpers.swift
//  aoc2021
//
//  Created by Chris McElroy on 11/30/21.
//


import Foundation
import Accelerate
import CryptoKit

// input functions //

public func inputStrings(_ separator: String = "\n") -> [String] {
	do {
		let home = FileManager.default.homeDirectoryForCurrentUser
		let name = "input" + (day < 10 ? "0" : "") + "\(day)"
		let filePath = projectFolder + "/aoc2021/" + name
		let file = URL(fileURLWithPath: filePath, relativeTo: home)
		let list = try String(contentsOf: file).dropLast().components(separatedBy: separator)
		return list
	} catch {
		print("Error: bad file name")
		return []
	}
}

public func inputInts(_ separator: String = "\n") -> [Int] {
	let input = inputStrings(separator)
	return input.compactMap { Int($0) ?? nil }
}

public func inputWords(_ wordSeparators: [String], _ lineSeparator: String = "\n") -> [[String]] {
	var words = inputStrings(lineSeparator).map { [$0] }
	for wordSeparator in wordSeparators {
		words = words.map { line in line.flatMap { $0.components(separatedBy: wordSeparator) } }
	}
	words = words.map { line in line.filter { $0 != "" } }
	return words
}

public func inputWords(_ wordSeparator: String = " ", _ lineSeparator: String = "\n") -> [[String]] {
	if wordSeparator == "" {
		return inputStrings(lineSeparator).map { $0.map { String($0) } }
	}
	return inputStrings(lineSeparator).map { $0.components(separatedBy: wordSeparator).filter { $0 != "" } }
}

public func inputSomeInts(words: [Int], _ wordSeparators: [String], _ lineSeparator: String = "\n") -> [[Int]] {
	let input = inputWords(wordSeparators, lineSeparator)
	return words.map { word in input.map { line in Int(line[word])! } }
}

public func inputSomeInts(words: [Int], _ wordSeparator: String = " ", _ lineSeparator: String = "\n") -> [[Int]] {
	let input = inputWords(wordSeparator, lineSeparator)
	return words.map { word in input.map { line in Int(line[word])! } }
}

public func inputIntArray(_ wordSeparators: [String], _ lineSeparator: String = "\n") -> [[Int]] {
	inputWords(wordSeparators, lineSeparator).map { $0.map { Int($0)! } }
}

public func inputIntArray(_ wordSeparator: String = " ", _ lineSeparator: String = "\n") -> [[Int]] {
	inputWords(wordSeparator, lineSeparator).map { $0.compactMap { Int($0) } }.filter { $0 != [] }
}

public func inputOneInt(word: Int, _ wordSeparator: String = " ", _ lineSeparator: String = "\n") -> [Int] {
	let input = inputWords(wordSeparator, lineSeparator)
	return input.map { line in Int(line[word])! }
}

public func inputOneInt(word: Int, _ wordSeparators: [String], _ lineSeparator: String = "\n") -> [Int] {
	let input = inputWords(wordSeparators, lineSeparator)
	return input.map { line in Int(line[word])! }
}

// shortcuts //

func make2DArray<Element>(repeating repeatedValue: Element, count1: Int, count2: Int) -> [[Element]] {
	(0..<count1).map { _ in Array(repeating: repeatedValue, count: count2) }
}

func print2DArray(width: Int, height: Int, shouldPrint: (C2) -> Bool) {
	for y in 0..<height {
		var line = ""
		for x in 0..<width {
			line.append(shouldPrint(C2(x, y)) ? "█" : " ")
		}
		print(line)
	}
	print()
}

func print2DArray(width: Int, height: Int, character: (C2) -> Character) {
	for y in 0..<height {
		var line = ""
		for x in 0..<width {
			line.append(character(C2(x, y)))
		}
		print(line)
	}
	print()
}

public extension Collection {
	func sum<N: AdditiveArithmetic>(_ partialResult: (Element) -> N) -> N {
		self.reduce(.zero, { $0 + partialResult($1) })
	}
	
	func count(where predicate: (Element) -> Bool) -> Int {
		self.reduce(0, { $0 + predicate($1).int })
	}
	
	func any(where predicate: (Element) -> Bool) -> Bool {
		for e in self where predicate(e) { return true }
		return false
	}
	
	func all(where predicate: (Element) -> Bool) -> Bool {
		for e in self where !predicate(e) { return false }
		return true
	}
	
	func map<T>(after predicate: (Element) -> Bool, _ transform: (Element) throws -> T) rethrows -> [T] {
		var started: Bool = false
		var newArray: [T] = []
		for e in self {
			if started {
				newArray.append(try transform(e))
			} else {
				started = predicate(e)
			}
		}
		return newArray
	}
	
	func map<T>(while predicate: (Element) -> Bool, _ transform: (Element) throws -> T) rethrows -> [T] {
		var newArray: [T] = []
		for e in self {
			if !predicate(e) { break }
			newArray.append(try transform(e))
		}
		return newArray
	}
}

public extension Collection where Indices.Iterator.Element == Index {
	func first(_ k: Int) -> SubSequence {
		return self.dropLast(count-k)
	}
	
	func last(_ k: Int) -> SubSequence {
		return self.dropFirst(count-k)
	}
	
	subscript(r: Range<Int>) -> SubSequence {
		get {
			self.first(r.upperBound).dropFirst(r.lowerBound)
		}
	}
	
	subscript(r: ClosedRange<Int>) -> SubSequence {
		get {
			self[r.lowerBound..<(r.upperBound + 1)]
		}
	}
	
	func each(_ k: Int) -> Array<SubSequence> {
		var array: Array<SubSequence> = []
		var i = 0
		while i < count {
			array.append(self[i..<(Swift.min(i + k, count))])
			i += k
		}
		return array
	}
	
	// from https://stackoverflow.com/a/54350570
	func toTuple() -> (Element) {
		return (self[0 as! Self.Index])
	}
	
	func toTuple() -> (Element, Element) {
		return (self[0 as! Self.Index], self[1 as! Self.Index])
	}
	
	func toTuple() -> (Element, Element, Element) {
		return (self[0 as! Self.Index], self[1 as! Self.Index], self[2 as! Self.Index])
	}
	
	func toTuple() -> (Element, Element, Element, Element) {
		return (self[0 as! Self.Index], self[1 as! Self.Index], self[2 as! Self.Index], self[3 as! Self.Index])
	}
	
	func toTuple() -> (Element, Element, Element, Element, Element) {
		return (self[0 as! Self.Index], self[1 as! Self.Index], self[2 as! Self.Index], self[3 as! Self.Index], self[4 as! Self.Index])
	}
}

public extension Collection where Element == Bool {
	func any() -> Bool {
		for e in self where e { return true }
		return false
	}
	
	func all() -> Bool {
		for e in self where !e { return false }
		return true
	}
}

public extension Collection where Element: Equatable {
	func repeats(of e: Element) -> Int {
		return self.filter({ $0 == e }).count
	}
}

public extension Collection where Element: Hashable {
	func occurs(min: Int) -> Array<Element> {
		var counts: Dictionary<Element, Int> = [:]
		self.forEach { counts[$0, default: 0] += 1 }
		return Array(counts.filter { $0.value >= min }.keys)
	}
}

public extension Collection where Element: Numeric {
	func product() -> Element {
		return self.reduce(1) { x,y in x*y }
	}
	
	func sum() -> Element {
		return self.reduce(0) { x,y in x+y }
	}
	
	func sum(_ partialResult: (Element) -> Element) -> Element {
		self.reduce(.zero, { $0 + partialResult($1) })
	}
}

public extension Collection where Element: AdditiveArithmetic {
	func twoSumTo(_ s: Element) -> [Element]? {
		guard let x = first(where: { contains(s-$0) }) else { return nil }
		return [x, s-x]
	}
	
	func nSumTo(_ s: Element, n: Int) -> [Element]? {
		if n == 2 { return twoSumTo(s) }
		for e in self {
			if var arr = nSumTo(s-e, n: n-1) {
				arr.append(e)
				return arr
			}
		}
		return nil
	}
}

public extension Array {
	subscript(w i: Int) -> Iterator.Element? {
		return self[index(startIndex, offsetBy: i % count)]
	}
	
	subscript(opt i: Int) -> Iterator.Element? {
		if i < 0 || i >= count { return nil }
		return self[i]
	}
	
	func first(_ k: Int) -> Self.SubSequence {
		return self.dropLast(count-k)
	}
	
	func last(_ k: Int) -> Self.SubSequence {
		return self.dropFirst(count-k)
	}
	
	subscript(r: Range<Int>) -> Self.SubSequence {
		get {
			self.first(r.upperBound).dropFirst(r.lowerBound)
		}
		set {
			let start = index(startIndex, offsetBy: r.lowerBound)
			let end = index(startIndex, offsetBy: r.upperBound)
			replaceSubrange(start..<end, with: newValue)
		}
	}
	
	subscript(r: ClosedRange<Int>) -> Self.SubSequence {
		get {
			self[r.lowerBound..<(r.upperBound + 1)]
		}
		set {
			self[r.lowerBound..<(r.upperBound + 1)] = newValue
		}
	}
	
	subscript(r: Range<Int>, by k: Int) -> Self {
		get {
			self[r].enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil }
		}
		set {
			var i = r.lowerBound
			for element in newValue {
				if i >= r.upperBound { break }
				self[i] = element
				i += k
			}
		}
	}
	
	subscript(r: ClosedRange<Int>, by k: Int) -> Self {
		get {
			self[r.lowerBound..<(r.upperBound + 1), by: k]
		}
		set {
			self[r.lowerBound..<(r.upperBound + 1), by: k] = newValue
		}
	}
	
	subscript(_ s: Int, _ e: Int) -> Self.SubSequence {
		return self.first(e).dropFirst(s)
	}
	
	mutating func pushOn(_ new: Element) {
		self = self.dropFirst() + [new]
	}
}

public extension Array where Element: MutableCollection {
	internal func coordinated() -> [(C2, Self.Element.Element)] {
		enumerated().flatMap { y, m1 in
			m1.enumerated().map { x, v in (C2(x, y), v) }
		}
	}
	
	internal func allPoints() -> [C2] {
		enumerated().flatMap { y, m1 in
			m1.enumerated().map { x, _ in C2(x, y) }
		}
	}
	
	internal subscript(_ p: C2) -> Self.Element.Element {
		get {
			self[p.y][p.x as! Element.Index]
		}
		set {
			self[p.y][p.x as! Element.Index] = newValue
		}
	}
	
	internal subscript(opt p: C2) -> Self.Element.Element? {
		get {
			inbound(p) ? self[p] : nil
		}
		set {
			if let v = newValue, inbound(p) {
				self[p] = v
			}
		}
	}
	
	internal func inbound(_ p: C2) -> Bool {
		(0..<count).contains(p.y) && (0..<self[0].count).contains(p.x)
	}
}

public extension Array where Element: Equatable {
	func fullSplit(separator: Element) -> Array<Self> {
		return self.split(whereSeparator: { $0 == separator}).map { Self($0) }
	}
}

public extension Range where Element: AdditiveArithmetic {
	func sum(_ partialResult: (Element) -> Element) -> Element {
		self.reduce(.zero, { $0 + partialResult($1) })
	}
}

public extension Dictionary {
	init<Element>(from array: [[Element]], key: Int, value: Int) where Element: Hashable {
		self.init()
		for part in array {
			self[part[key] as! Key] = part[value] as? Value
		}
	}
	
	init<Element>(from array: [[Element]], key: Int) where Value == [Element], Element: Hashable {
		self.init()
		for part in array {
			self[part[key] as! Key] = part
		}
	}
	
	init(_ dictArray: [[Self.Key: Self.Value]]) {
		self.init()
		for dict in dictArray {
			for (key, value) in dict {
				self[key] = value
			}
		}
	}
}

public extension String {
//	func fullSplit(separator: Character) -> [String] {
//		let s = self.split(separator: separator, maxSplits: .max, omittingEmptySubsequences: false).map { String($0) }
//		if s.last == "" {
//			return s.dropLast(1)
//		} else {
//			return s
//		}
//	}
	
	func occurs(min: Int) -> String {
		var counts: Dictionary<Character, Int> = [:]
		self.forEach { counts[$0, default: 0] += 1 }
		return String(counts.filter { $0.value >= min }.keys)
	}
	
	subscript(i: Int) -> Character {
		get {
			self[index(startIndex, offsetBy: i)]
		}
		set {
			let index = index(startIndex, offsetBy: i)
			replaceSubrange(index...index, with: String(newValue))
		}
	}
	
	subscript(w i: Int) -> Character? {
		return self[index(startIndex, offsetBy: i % count)]
	}
	
	subscript(opt i: Int) -> Character? {
		if i < 0 || i >= count { return nil }
		return self[i]
	}
	
	subscript(r: Range<Int>) -> String {
		get {
			String(self.first(r.upperBound).dropFirst(r.lowerBound))
		}
		set {
			let start = index(startIndex, offsetBy: r.lowerBound)
			let end = index(startIndex, offsetBy: r.upperBound)
			replaceSubrange(start..<end, with: newValue)
		}
	}
	
	subscript(r: ClosedRange<Int>) -> String {
		get {
			self[r.lowerBound..<(r.upperBound + 1)]
		}
		set {
			self[r.lowerBound..<(r.upperBound + 1)] = newValue
		}
	}
	
	subscript(r: Range<Int>, by k: Int) -> String {
		get {
			return String(self[r].enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil })
		}
		set {
			var i = r.lowerBound
			for element in newValue {
				if i >= r.upperBound { break }
				self[i] = element
				i += k
			}
		}
	}
	
	subscript(r: ClosedRange<Int>, by k: Int) -> String {
		get {
			self[r.lowerBound..<(r.upperBound + 1), by: k]
		}
		set {
			self[r.lowerBound..<(r.upperBound + 1), by: k] = newValue
		}
	}
	
	func firstIndex(of element: Character) -> Int? {
		firstIndex(of: element)?.utf16Offset(in: self)
	}
	
	func lastIndex(of element: Character) -> Int? {
		lastIndex(of: element)?.utf16Offset(in: self)
	}
}

public extension StringProtocol {
	subscript(offset: Int) -> Character {
		self[index(startIndex, offsetBy: offset)]
	}
	
	subscript(_ s: Int, _ e: Int) -> SubSequence {
		return self.first(e).dropFirst(s)
	}
	
	func first(_ k: Int) -> Self.SubSequence {
		return self.dropLast(count-k)
	}
	
	func last(_ k: Int) -> Self.SubSequence {
		return self.dropFirst(count-k)
	}
	
	subscript(r: Range<Int>) -> String {
		get {
			String(self.first(r.lowerBound).dropFirst(r.upperBound))
		}
	}
	
	subscript(r: ClosedRange<Int>) -> String {
		get {
			self[r.lowerBound..<(r.upperBound + 1)]
		}
	}
	
	subscript(r: Range<Int>, by k: Int) -> String {
		get {
			return String(self[r].enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil })
		}
	}
	
	subscript(r: ClosedRange<Int>, by k: Int) -> String {
		get {
			self[r.lowerBound..<(r.upperBound + 1), by: k]
		}
	}
	
	func isin(_ string: Self?) -> Bool {
		return string?.contains(self) == true
	}
	
	func repititions(n: Int) -> [Character] {
		var last: Character = " "
		var count = 0
		var output: [Character] = []
		
		for c in self {
			if last == c {
				count += 1
				if count == n {
					output.append(c)
				}
			} else {
				last = c
				count = 1
			}
		}
		
		return output
	}
	
	func hexToInt() -> Int {
		return Int(self, radix: 16)!
	}
	
	func hexToBinaryArray() -> [Int] {
		flatMap { $0.hexToBinaryArray() }
	}
	
	func hexToBinaryString() -> String {
		map({ $0.hexToBinaryString() }).joined()
	}
}

public extension Character {
	static func +(lhs: Character, rhs: Int) -> Character {
		if lhs.isLetter {
			let aVal: UInt32 = lhs.isUppercase ? 65 : 97
			if let value = lhs.unicodeScalars.first?.value {
				if let scalar = UnicodeScalar((value - aVal + UInt32(rhs)) % 26 + aVal) {
					return Character(scalar)
				}
			}
		}
		return lhs
	}
	
	func hexToInt() -> Int {
		return Int(String(self), radix: 16)!
	}
	
	func hexToBinaryArray() -> [Int] {
		switch self {
		case "0": return [0, 0, 0, 0]
		case "1": return [0, 0, 0, 1]
		case "2": return [0, 0, 1, 0]
		case "3": return [0, 0, 1, 1]
		case "4": return [0, 1, 0, 0]
		case "5": return [0, 1, 0, 1]
		case "6": return [0, 1, 1, 0]
		case "7": return [0, 1, 1, 1]
		case "8": return [1, 0, 0, 0]
		case "9": return [1, 0, 0, 1]
		case "A": return [1, 0, 1, 0]
		case "B": return [1, 0, 1, 1]
		case "C": return [1, 1, 0, 0]
		case "D": return [1, 1, 0, 1]
		case "E": return [1, 1, 1, 0]
		default: return [1, 1, 1, 1]
		}
	}
	
	func hexToBinaryString() -> String {
		switch self {
		case "0": return "0000"
		case "1": return "0001"
		case "2": return "0010"
		case "3": return "0011"
		case "4": return "0100"
		case "5": return "0101"
		case "6": return "0110"
		case "7": return "0111"
		case "8": return "1000"
		case "9": return "1001"
		case "A": return "1010"
		case "B": return "1011"
		case "C": return "1100"
		case "D": return "1101"
		case "E": return "1110"
		default: return "1111"
		}
	}
}

extension RangeReplaceableCollection {
	// from https://stackoverflow.com/questions/25162500/apple-swift-generate-combinations-with-repetition
	// I should use rangereplacablecollection for everything i think
	func combinationsWithReplacement(length n: Int) -> [Self] {
		guard n > 0 else { return [.init()] }
		guard let first = first else { return [] }
		return combinationsWithReplacement(length: n - 1).map { Self([first]) + $0 } + Self(dropFirst()).combinationsWithReplacement(length: n)
	}
	
	func combinationsWithoutReplacement(length n: Int) -> [Self] {
		guard n > 0 else { return [.init()] }
		guard let first = first else { return [] }
		return Self(dropFirst()).combinationsWithoutReplacement(length: n - 1).map { Self([first]) + $0 } + Self(dropFirst()).combinationsWithoutReplacement(length: n)
	}
	
	// TODO do this for range replacable
	// TODO do all of these for sets
//	// permutations from https://stackoverflow.com/questions/34968470/calculate-all-permutations-of-a-string-in-swift
//	func permutations(actually i do want a length) -> [Self] {
////		guard cou > 0 else { return [.init()] }
//		if isEmpty { return [Self()] }
//		let next Self(dropFirst()).permutations() (length: n - 1).map { Self([first]) + $0 } + Self(dropFirst()).combinationsWithReplacement(length: n)
//	}
	
	mutating func insert(_ newElement: Self.Element, _ i: Int) {
		self.insert(newElement, at: index(self.startIndex, offsetBy: i))
	}
}

// permutations from https://stackoverflow.com/questions/34968470/calculate-all-permutations-of-a-string-in-swift
func permutations<T>(len n: Int, _ a: inout [T], output: inout [[T]]) {
	if n == 1 { output.append(a); return }
	for i in stride(from: 0, to: n, by: 1) {
		permutations(len: n-1, &a, output: &output)
		a.swapAt(n-1, (n%2 == 1) ? 0 : i)
	}
}

public extension Comparable {
	func isin(_ collection: Array<Self>?) -> Bool {
		return collection?.contains(self) == true
	}
	
	mutating func swap(_ x: Self, _ y: Self) {
		self = (self == x) ? y : x
	}
}

public extension Equatable {
	func isin(_ one: Self, _ two: Self, _ three: Self) -> Bool {
		return self == one || self == two || self == three
	}
}

public extension Hashable {
	func isin(_ collection: Set<Self>?) -> Bool {
		return collection?.contains(self) == true
	}
}

public extension Character {
	func isin(_ string: String?) -> Bool {
		return string?.contains(self) == true
	}
}

public extension Numeric where Self: Comparable {
	func isin(_ range: ClosedRange<Self>?) -> Bool {
		return range?.contains(self) == true
	}
	
	func isin(_ range: Range<Self>?) -> Bool {
		return range?.contains(self) == true
	}
}

infix operator ** : MultiplicationPrecedence
public extension Numeric {
	func sqrd() -> Self {
		self*self
	}
	
	static func ** (lhs: Self, rhs: Int) -> Self {
		(0..<rhs).reduce(1) { x,y in x*lhs }
	}
}

public extension Bool {
	var int: Int { self ? 1 : 0 }
}

func timed(_ run: () -> Void) {
	let start = Date().timeIntervalSinceReferenceDate
	run()
	let end = Date().timeIntervalSinceReferenceDate
	print("in:", end-start)
}

public extension BinaryFloatingPoint {
	var isWhole: Bool { self.truncatingRemainder(dividingBy: 1) == 0 }
	var isEven: Bool { Int(self) % 2 == 0 }
	var isOdd: Bool { Int(self) % 2 == 1 }
	var int: Int? { isWhole ? Int(self) : nil }
}

public extension BinaryInteger {
	var isEven: Bool { self % 2 == 0 }
	var isOdd: Bool { self % 2 == 1 }
}

struct C2: Equatable, Hashable, AdditiveArithmetic {
	var x: Int
	var y: Int
	
	init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}
	
	static let zeroAdjacents = [(-1,0),(0,-1),(0,1),(1,0)]
	static let zeroAdjacentsWithSelf = [(-1,0),(0,-1),(0,0),(0,1),(1,0)]
	// in reading order
	static let zeroNeighbors = [(-1,-1),(0,-1),(1,-1),(-1,0),(1,0),(-1,1),(0,1),(1,1)]
	static let zeroNeighborsWithSelf = [(-1,-1),(0,-1),(1,-1),(-1,0),(0,0),(1,0),(-1,1),(0,1),(1,1)]
	var adjacents: [C2] { C2.zeroAdjacents.map({ C2(x + $0.0, y + $0.1) }) }
	var neighbors: [C2] { C2.zeroNeighbors.map({ C2(x + $0.0, y + $0.1) }) }
	var adjacentsWithSelf: [C2] { C2.zeroAdjacentsWithSelf.map({ C2(x + $0.0, y + $0.1) }) }
	var neighborsWithSelf: [C2] { C2.zeroNeighborsWithSelf.map({ C2(x + $0.0, y + $0.1) }) }
	
	static var zero: C2 = C2(0, 0)
	
	mutating func rotateLeft() {
		let tempX = x
		x = -y
		y = tempX
	}
	
	mutating func rotateRight() {
		let tempX = x
		x = y
		y = -tempX
	}
	
	mutating func rotate(left: Bool) {
		left ? rotateLeft() : rotateRight()
	}
	
	func manhattanDistance() -> Int {
		abs(x) + abs(y)
	}
	
	func vectorLength() -> Double {
		sqrt(Double(x*x + y*y))
	}
	
	static func + (lhs: C2, rhs: C2) -> C2 {
		C2(lhs.x + rhs.x, lhs.y + rhs.y)
	}
	
	static func - (lhs: C2, rhs: C2) -> C2 {
		C2(lhs.x - rhs.x, lhs.y - rhs.y)
	}
}

struct C3: Equatable, Hashable, AdditiveArithmetic {
	var x: Int
	var y: Int
	var z: Int
	
	init(_ x: Int, _ y: Int, _ z: Int) {
		self.x = x
		self.y = y
		self.z = z
	}
	
	static let zeroAdjacents = [(-1,0,0),(0,-1,0),(0,0,-1),(0,0,1),(0,1,0),(1,0,0)]
	static let zeroNeighbors = [(-1,-1,-1),(-1,-1,0),(-1,-1,1),(-1,0,-1),(-1,0,0),(-1,0,1),(-1,1,-1),(-1,1,0),(-1,1,1),
								(0,-1,-1),(0,-1,0),(0,-1,1),(0,0,-1),(0,0,1),(0,1,-1),(0,1,0),(0,1,1),
								(1,-1,-1),(1,-1,0),(1,-1,1),(1,0,-1),(1,0,0),(1,0,1),(1,1,-1),(1,1,0),(1,1,1)]
	var adjacents: [C3] { C3.zeroAdjacents.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) }
	var neighbors: [C3] { C3.zeroNeighbors.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) }
	var adjacentsWithSelf: [C3] { C3.zeroAdjacents.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) + [self] }
	var neighborsWithSelf: [C3] { C3.zeroNeighbors.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) + [self] }
	
	static var zero: C3 = C3(0, 0, 0)
	
	func manhattanDistance() -> Int {
		abs(x) + abs(y) + abs(z)
	}
	
	func vectorLength() -> Double {
		sqrt(Double(x*x + y*y + z*z))
	}
	
	static func + (lhs: C3, rhs: C3) -> C3 {
		C3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
	}
	
	static func - (lhs: C3, rhs: C3) -> C3 {
		C3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
	}
	
	func redirect(to perspective: Int) -> C3 {
		var new: C3
		switch perspective % 4 {
		case 0: new = self
		case 1: new = C3(x, z, -y)
		case 2: new = C3(x, -y, -z)
		default: new = C3(x, -z, y)
		}
		
		switch (perspective / 4) % 4 {
		case 0: break
		case 1: new = C3(new.y, -new.x, new.z)
		case 2: new = C3(-new.x, -new.y, new.z)
		default: new = C3(-new.y, new.x, new.z)
		}
		
		switch (perspective / 16) % 4 {
		case 0: break
		case 1: new = C3(new.z, new.y, -new.x)
		case 2: new = C3(-new.x, new.y, -new.z)
		default: new = C3(-new.z, new.y, new.x)
		}
		
		return new
	}
}

struct Bound2: Equatable, Hashable {
	var x: Range<Int>
	var y: Range<Int>
	
	init(_ x: Range<Int>, _ y: Range<Int>) {
		self.x = x
		self.y = y
	}
	
	init() {
		self.x = Int.min..<Int.max
		self.y = Int.min..<Int.max
	}
	
	func overlap(with other: Bound2) -> Bound2? {
		guard x.overlaps(other.x) && y.overlaps(other.y) else { return nil }
		return Bound2(x.clamped(to: other.x), y.clamped(to: other.y))
	}
	
	var count: Int {
		x.count * y.count
	}
}

struct ClosedBound2: Equatable, Hashable {
	var x: ClosedRange<Int>
	var y: ClosedRange<Int>
	
	init(_ x: ClosedRange<Int>, _ y: ClosedRange<Int>) {
		self.x = x
		self.y = y
	}
	
	init() {
		self.x = Int.min...Int.max
		self.y = Int.min...Int.max
	}
	
	func overlap(with other: ClosedBound2) -> ClosedBound2? {
		guard x.overlaps(other.x) && y.overlaps(other.y) else { return nil }
		return ClosedBound2(x.clamped(to: other.x), y.clamped(to: other.y))
	}
	
	var count: Int {
		x.count * y.count
	}
}

struct Bound3: Equatable, Hashable {
	var x: Range<Int>
	var y: Range<Int>
	var z: Range<Int>
	
	init(_ x: Range<Int>, _ y: Range<Int>, _ z: Range<Int>) {
		self.x = x
		self.y = y
		self.z = z
	}
	
	init() {
		self.x = Int.min..<Int.max
		self.y = Int.min..<Int.max
		self.z = Int.min..<Int.max
	}
	
	func overlap(with other: Bound3) -> Bound3? {
		guard x.overlaps(other.x) && y.overlaps(other.y) && z.overlaps(other.z) else { return nil }
		return Bound3(x.clamped(to: other.x), y.clamped(to: other.y), z.clamped(to: other.z))
	}
	
	var count: Int {
		x.count * y.count * z.count
	}
}

struct ClosedBound3: Equatable, Hashable {
	var x: ClosedRange<Int>
	var y: ClosedRange<Int>
	var z: ClosedRange<Int>
	
	init(_ x: ClosedRange<Int>, _ y: ClosedRange<Int>, _ z: ClosedRange<Int>) {
		self.x = x
		self.y = y
		self.z = z
	}
	
	init() {
		self.x = Int.min...Int.max
		self.y = Int.min...Int.max
		self.z = Int.min...Int.max
	}
	
	func overlap(with other: ClosedBound3) -> ClosedBound3? {
		guard x.overlaps(other.x) && y.overlaps(other.y) && z.overlaps(other.z) else { return nil }
		return ClosedBound3(x.clamped(to: other.x), y.clamped(to: other.y), z.clamped(to: other.z))
	}
	
	var count: Int {
		x.count * y.count * z.count
	}
}

func MD5(of string: String) -> String {
	String(Insecure.MD5.hash(data: (string).data(using: .utf8)!).description.dropFirst(12))
}

// adapted from https://www.raywenderlich.com/947-swift-algorithm-club-swift-linked-list-data-structure
public class LinkedNode<Element> {
	var value: Element
	weak var prev: LinkedNode?
	var next: LinkedNode?
	
	init (_ value: Element) {
		self.value = value
	}
}

public struct ListIterator<Element>: IteratorProtocol {
	var current: LinkedNode<Element>?
	
	public mutating func next() -> Element? {
		let v = current?.value
		current = current?.next
		return v
	}
}

public struct List<Element>: ExpressibleByArrayLiteral, Sequence, CustomStringConvertible {
	var head: LinkedNode<Element>?
	var tail: LinkedNode<Element>?
	var count: Int
	
	init() {
		head = nil
		tail = nil
		count = 0
	}
	
	public typealias ArrayLiteralElement = Element
	public init(arrayLiteral elements: Element...) {
		guard let first = elements.first else {
			head = nil
			tail = nil
			count = 0
			return
		}
		var node = LinkedNode(first)
		head = node
		var i = 1
		while i < elements.count {
			let newNode = LinkedNode(elements[i])
			node.next = newNode
			newNode.prev = node
			node = newNode
			i += 1
		}
		tail = node
		count = elements.count
	}
	
	init<Source>(_ sequence: Source) where Element == Source.Element, Source : Sequence {
		count = 0
		var node: LinkedNode<Element>?
		for (i, v) in sequence.enumerated() {
			let newNode = LinkedNode(v)
			node?.next = newNode
			newNode.prev = node
			node = newNode
			count += 1
			if i == 0 { head = newNode }
		}
		tail = node
	}
	
	init(_ array: Array<Element>) {
		guard let first = array.first else {
			head = nil
			tail = nil
			count = 0
			return
		}
		var node = LinkedNode(first)
		head = node
		var i = 1
		while i < array.count {
			let newNode = LinkedNode(array[i])
			node.next = newNode
			newNode.prev = node
			node = newNode
			i += 1
		}
		tail = node
		count = array.count
	}
	
	public func makeIterator() -> ListIterator<Element> {
		ListIterator(current: head)
	}
	
	var isEmpty: Bool {
		return head == nil
	}

	var first: Element? {
		return head?.value
	}

	var last: Element? {
		return tail?.value
	}
	
	public var description: String {
		if count == 0 { return "[]" }
		var d = "["
		for e in self {
			if let printable = e as? CustomStringConvertible {
				d.append(printable.description + ", ")
			} else {
				return "Elements not printable. Count: " + String(count)
			}
		}
		return d.dropLast(2) + "]"
	}
	
	mutating func prepend(_ newElement: Element) {
		let newNode = LinkedNode(newElement)
		if let headNode = head {
			newNode.next = headNode
			headNode.prev = newNode
		} else {
			tail = newNode
		}
		head = newNode
		count += 1
	}
	
	mutating func append(_ newElement: Element) {
		let newNode = LinkedNode(newElement)
		if let tailNode = tail {
			newNode.prev = tailNode
			tailNode.next = newNode
		} else {
			head = newNode
		}
		tail = newNode
		count += 1
	}
	
	mutating func removeFirst() {
		if !isEmpty { count -= 1 }
		head = head?.next
	}
	
	mutating func removeLast() {
		if !isEmpty { count -= 1 }
		tail = tail?.prev
	}
	
	mutating func removeFirst(_ n: Int) {
		for _ in stride(from: 0, to: n, by: 1) {
			removeFirst()
		}
	}
	
	mutating func removeLast(_ n: Int) {
		for _ in stride(from: 0, to: n, by: 1) {
			removeLast()
		}
	}
	
	mutating func popLast() -> Element? {
		if !isEmpty { count -= 1 }
		let v = tail?.value
		tail = tail?.prev
		return v
	}
	
	mutating func popFirst() -> Element? {
		if !isEmpty { count -= 1 }
		let v = head?.value
		head = head?.next
		return v
	}
}

extension List where Element: AdditiveArithmetic {
	public func sum() -> Element {
		guard var current = head else { return .zero }
		var sum = current.value
		while let next = current.next {
			sum += next.value
			current = next
		}
		return sum
	}
}

class Cycle<Element>: CustomStringConvertible {
	private var currentNode: LinkedNode<Element>?
	
	var current: Element? { currentNode?.value }
	
	func insertNext(_ newElement: Element) {
		let newNode = LinkedNode(newElement)
		if let currentNode = currentNode {
			let next = currentNode.next
			currentNode.next = newNode
			newNode.prev = currentNode
			newNode.next = next
			next?.prev = newNode
		} else {
			newNode.prev = newNode
			newNode.next = newNode
			currentNode = newNode
		}
	}
	
	func insertPrev(_ newElement: Element) {
		let newNode = LinkedNode(newElement)
		if let currentNode = currentNode {
			let prev = currentNode.prev
			currentNode.prev = newNode
			newNode.prev = prev
			newNode.next = currentNode
			prev?.next = newNode
		} else {
			newNode.prev = newNode
			newNode.next = newNode
			currentNode = newNode
		}
	}
	
	func shiftCurrent(by n: Int) {
		if currentNode == nil { return }
		if n > 0 {
			currentNode = currentNode!.next
			shiftCurrent(by: n - 1)
		} else if n < 0 {
			currentNode = currentNode!.prev
//			print(self)
			shiftCurrent(by: n + 1)
		}
	}
	
	@discardableResult func removeAndGoToNext() -> Element? {
		let value = currentNode?.value
		if currentNode?.next === currentNode {
			currentNode = nil
			return nil
		} else {
			let prev = currentNode?.prev
			currentNode = currentNode?.next
			currentNode?.prev = prev
			prev?.next = currentNode
		}
		return value
	}
	
	public var description: String {
		var text = "["
		var node = currentNode

		repeat {
			text += "\(node!.value)"
			node = node!.next
			if node !== currentNode { text += ", " }
		} while node !== currentNode
		return text + "]"
	}
}

public extension Set {
	/// Breadth first search function
	///
	/// Starts with the given set, which has values added to it as their found
	///
	/// Note that this automatically stops when there's nothing left to search!
	///
	/// - Parameter search: (expandUsing) Function of current value and all found values.
	///   Should return all the new values to inpsect as solutions or continue searching with
	/// - Parameter shouldContinue: (continueWhile) Function of number of steps and all found values.
	///   Should return a bool indicating whether the search should continue.
	///   Note that whether there are new values to search is handled automatically!
	///   Implicitly set to return true.
	/// - Parameter solution: (stopIf)  Function of value, number of steps done, and all found values.
	///   Should return true if the search should stop (if this is a solution).
	///   Implicitly set to return false.
	/// - Returns: all found values
	@discardableResult func bfs(expandUsing search: (Element, Self) -> [Element], continueWhile shouldContinue: (Int, Self) -> Bool = { _, _ in true }, stopIf solution: ((Element, Int, Self) -> Bool) = { _,_,_ in false }) -> Self {
		var steps = 0
		var current = self
		var found = self
		
		while shouldContinue(steps, found) && !current.isEmpty {
			steps += 1
			var next: Self = []
			
			for a in current {
				for b in search(a, found) {
					if solution(b, steps, found) { return found }
					
					if found.insert(b).inserted {
						next.insert(b)
					}
				}
			}
			
			current = next
		}
		
		return found
	}
	
	/// Breadth first search forward only function
	/// use this when your search can't go backwards, so you don't need to check if you've already been somewhere
	///
	/// Starts with the given set
	///
	/// Note that this automatically stops when there's nothing left to search!
	///
	/// - Parameter search: (expandUsing) Function of the current value.
	///   Should return all the new values to inpsect as solutions or continue searching with
	/// - Parameter shouldContinue: (continueWhile) Function of number of steps.
	///   Should return a bool indicating whether the search should continue.
	///   Note that whether there are new values to search is handled automatically!
	///   Implicitly set to return true.
	/// - Parameter solution: (stopIf)  Function of value, number of steps done.
	///   Should return true if the search should stop (if this is a solution).
	///   Implicitly set to return false.
	func bfsForwardOnly(expandUsing search: (Element) -> [Element], continueWhile shouldContinue: (Int) -> Bool = { _ in true }, stopIf solution: ((Element, Int) -> Bool) = { _,_ in false }) {
		var steps = 0
		var current = self
		
		while shouldContinue(steps) && !current.isEmpty {
			steps += 1
			var next: Self = []
			
			for a in current {
				for b in search(a) {
					if solution(b, steps) { return }
					
					next.insert(b)
				}
			}
			
			current = next
		}
	}
}

// from https://stackoverflow.com/questions/28349864/algorithm-for-lcm-of-doubles-in-swift
// GCD of two numbers:
func gcd(_ a: Int, _ b: Int) -> Int {
	var (a, b) = (a, b)
	while b != 0 {
		(a, b) = (b, a % b)
	}
	return abs(a)
}

// GCD of a vector of numbers:
func gcd(_ vector: [Int]) -> Int {
	return vector.reduce(0, gcd)
}

// LCM of two numbers:
func lcm(_ a: Int, _ b: Int) -> Int {
	return (a / gcd(a, b)) * b
}

// LCM of a vector of numbers:
func lcm(_ vector: [Int]) -> Int {
	return vector.reduce(1, lcm)
}

extension Int {
	var isPrime: Bool {
		// from https://stackoverflow.com/questions/31105664/check-if-a-number-is-prime
		guard self >= 2     else { return false }
		guard self != 2     else { return true  }
		guard self % 2 != 0 else { return false }
		return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
	}
}

enum Operation {
	case set, inc, dec, add, sub, mod, mult, div
	case jump, jnz, jez, jgz, jlz
}

func intOrReg(val: String, reg: [String: Int]) -> Int {
	if let n = Int(val) { return n }
	return reg[val] ?? 0
}

func compute(with language: [String: Operation], program: [[String]] = inputWords(), reg: inout [String: Int], line i: inout Int) {
	
	let line = program[i]
	let v1 = intOrReg(val: line[1], reg: reg)
	let v2 = line.count < 3 ? 0 : intOrReg(val: line[2], reg: reg)
	
	switch language[line[0]] {
	case .set:
		reg[line[1]] = v2
	case .inc:
		reg[line[1], default: 0] += 1
	case .dec:
		reg[line[1], default: 0] -= 1
	case .add:
		reg[line[1], default: 0] += v2
	case .sub:
		reg[line[1], default: 0] -= v2
	case .mod:
		reg[line[1], default: 0] %= v2
	case .mult:
		reg[line[1], default: 0] *= v2
	case .div:
		reg[line[1], default: 0] /= v2
		
	case .jump:
		i += v1 - 1
	case .jnz:
		if v1 != 0 { i += v2 - 1 }
	case .jez:
		if v1 == 0 { i += v2 - 1 }
	case .jgz:
		if v1 > 0 { i += v2 - 1 }
	case .jlz:
		if v1 < 0 { i += v2 - 1 }
		
	case .none:
		break
	}
	
	i += 1
	
}

