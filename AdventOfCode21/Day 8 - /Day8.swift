//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation


/// only for bijective dicts with keys are strings as in these challenge
extension Dictionary where Value : Equatable {
    func keyFor(value : Value) -> String {
        return self.filter { $1 == value }.map { $0.0 as! String }.first ?? "NoValue"
    }
}
extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
}

/// I removed the newlines in file input-8a manually, as said on the website, it was only done on the example to format the text on the page but the puzzle input had no such things
func day8() {
    let input: [(a: String, b: String)] = getInputDay8()
    
    /// part 1!
    let solutionDay8a = input.map { $0.b }
        .reduce(0) {
            return $0 + $1
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: .whitespaces)
                .reduce(0) {
                    if $1.count == 2 || $1.count == 3 || $1.count == 4 || $1.count == 7 {
                        return $0 + 1
                    }
                    return $0
                }
        }
    
    /// part 2!
    var solutionDay8b = 0
    
    for line in input {
        
        /// init my dict - it will be overwritten everyline...
        var dict: [String: String] = [:]
        
        var linePartA = line.a.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: .whitespaces)
        let linePartB = line.b.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: .whitespaces)
        
        /// first pass - the first part of the line, `linePartA`is the list of the 10 digits "codes" I need to decode the second part of the line.
        /// The first digits are easy
        for segments in linePartA {
            
            let segmentCount: SegmentCount = SegmentCount(digit: segments)
            
            if segmentCount == .two {
                for entry in segments.permutations() {
                    dict[String(entry)] = "1"
                }
                linePartA.remove(element: segments)
            }
            if segmentCount == .three {
                for entry in segments.permutations() {
                    dict[String(entry)] = "7"
                }
                linePartA.remove(element: segments)
            }
            if segmentCount == .four {
                for entry in segments.permutations() {
                    dict[String(entry)] = "4"
                }
                linePartA.remove(element: segments)
            }
            if segmentCount == .seven {
                for entry in segments.permutations() {
                    dict[String(entry)] = "8"
                }
                linePartA.remove(element: segments)
            }
        }
        
        /// second pass. I can get number `3` The only one which has 5 segments and is a superset of the segments needed for `1`
        /// . Of course `7`, `4`, `3` are already removed
        for segments in linePartA {
            let segmentCount: SegmentCount = SegmentCount(digit: segments)
            if segmentCount == .five {
                if Set(segments).isSuperset(of: Set(dict.keyFor(value: "1"))){
                    for entry in segments.permutations() {
                        dict[String(entry)] = "3"
                    }
                    linePartA.remove(element: segments)
                }
            }
        }
        
        /// het the remaining `5` and `2` which have `5` segments and `5` is found by subtracting the segments used for `3` and checking if it is a subset of `4`
        for segments in linePartA {
            let segmentCount: SegmentCount = SegmentCount(digit: segments)
            if segmentCount == .five {
                if Set(segments).subtracting(Set(dict.keyFor(value: "3"))).isSubset(of: Set(dict.keyFor(value: "4"))) {
                    for entry in segments.permutations() {
                        dict[String(entry)] = "5"
                    }
                    linePartA.remove(element: segments)
                } else {
                    for entry in segments.permutations() {
                        dict[String(entry)] = "2"
                    }
                    linePartA.remove(element: segments)
                }
            }
        }
        
        /// get `9` . At this stage the only one which is the union of the elements needed for `3` and `5`
        for segments in linePartA {
            let segmentCount: SegmentCount = SegmentCount(digit: segments)
            if segmentCount == .six {
                if Set(segments) ==
                    Set(dict.keyFor(value: "3")).union(Set(dict.keyFor(value: "5"))) {
                    for entry in segments.permutations() {
                        dict[String(entry)] = "9"
                    }
                    linePartA.remove(element: segments)
                }
            }
        }
        
        
        /// get the remaining `6` and `0`
        for segments in linePartA {
            let segmentCount: SegmentCount = SegmentCount(digit: segments)
            if segmentCount == .six {
                if Set(segments) == Set(dict.keyFor(value: "8")).subtracting(Set(dict.keyFor(value: "1"))).union( Set(dict.keyFor(value: "5")))   {
                    for entry in segments.permutations() {
                        dict[String(entry)] = "6"
                    }
                    linePartA.remove(element: segments)
                } else {
                    for entry in segments.permutations() {
                        dict[String(entry)] = "0"
                    }
                    linePartA.remove(element: segments)
                }
            }
        }
        
        /// at the end of each line I get the 4 digits using the dict and adding it to the total
        var solutionString = ""
        for digit in linePartB {
            solutionString += dict[digit] ?? ""
        }
        solutionDay8b += Int(solutionString)!
    }
    
    
    print("Solution day8 - Part1: \(solutionDay8a)")
    print("Solution day8 - Part2: \(solutionDay8b)")
}


func getInputDay8() -> [(String,String)] {
    var input: [(String,String)] = [(a: "", b:"")]
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-8a", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .trimmingCharacters(in: .newlines)
                    .components(separatedBy: .newlines)
                    .map {
                        let splitString = $0.components(separatedBy: "|" )
                        return (a:splitString[0],b: splitString[1])
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}


enum SegmentCount: String {
    case two, three, four, five, six, seven
    init(digit: String) {
        switch digit.count {
        case 2:
            self = .two
        case 3:
            self = .three
        case 4:
            self = .four
        case 5:
            self = .five
        case 6:
            self = .six
        case 7:
            self = .seven
        default:
            self = .two
        }
    }
}
