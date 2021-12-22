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
    let solutionDay8a = input.map { $0.1 }
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
        //var linePartA = ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"]
        var linePartB = line.b.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: .whitespaces)
        
        /// first pass - the first part is the list of the 10 digits "codes"
        for segments in linePartA {
            
            let digit: SegmentCount = SegmentCount(digit: segments)
            
            switch digit { // like .two segments
            case  .two:
                for entry in segments.permutations() {
                    dict[String(entry)] = "1"
                }
                linePartA.remove(element: segments)
            case .three:
                for entry in segments.permutations() {
                    dict[String(entry)] = "7"
                }
                linePartA.remove(element: segments)
                
            case .four:
                for entry in segments.permutations() {
                    dict[String(entry)] = "4"
                }
                linePartA.remove(element: segments)
            case .seven:
                for entry in segments.permutations() {
                    dict[String(entry)] = "8"
                }
                linePartA.remove(element: segments)
            case .five, .six:
                break
            }
        }
        
        /// second pass
        for segments in linePartA {
            let digit: SegmentCount = SegmentCount(digit: segments)
            if digit == .five {
                if Set(segments).isSuperset(of: Set(dict.keyFor(value: "1"))){
                    for entry in segments.permutations() {
                        dict[String(entry)] = "3"
                    }
                    linePartA.remove(element: segments)
                }
            }
        }
        
        /// het the remaining 5 and 2
        for segments in linePartA {
            let digit: SegmentCount = SegmentCount(digit: segments)
            if digit == .five {
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
        
        /// het the remaining 9
        for segments in linePartA {
            let digit: SegmentCount = SegmentCount(digit: segments)
            if digit == .six {
                if Set(segments) ==
                    Set(dict.keyFor(value: "3")).union(Set(dict.keyFor(value: "5"))) {
                    for entry in segments.permutations() {
                        dict[String(entry)] = "9"
                    }
                    linePartA.remove(element: segments)
                }
            }
        }
        
        
        /// het the remaining 6 and 0
        for segments in linePartA {
            let digit: SegmentCount = SegmentCount(digit: segments)
            if digit == .six {
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
        
        var solutionString = ""

        for num in linePartB {
            solutionString += dict[num] ?? ""
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
            let charSet = CharacterSet(charactersIn: "|")
            do {
                input = try String(contentsOf: inputFileURL)
                    .trimmingCharacters(in: .newlines)
                    .components(separatedBy: .newlines)
                
                    .map {
                        let splitString = $0.components(separatedBy: "|" )
                        print(splitString[0])
                        print(splitString[1])
                        let (a,b) : (a: String,b: String) = (a:splitString[0],b: splitString[1])
                        return (a:a,b:b)
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
