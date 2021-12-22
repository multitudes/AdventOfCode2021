//: [Previous](@previous)

import Foundation
import Algorithms

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


func getInputDay8a() -> [(String,String)] {
    var input: [(String,String)] = [(a: "", b:"")]
    
    do {
        if let inputFileURL = Bundle.main.url(forResource: "input-8a", withExtension: "txt") {
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

let input: [(a: String, b: String)] = getInputDay8a()

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
solutionDay8a

//let part2 = input.map { $0.0 }
//part2

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

/// part 2!
var solutionTotal = 0

for line in input {
    
    //print(line)
    var dict: [String: String] = [:]
    /// create my dict
    var linePartA = line.a.trimmingCharacters(in: .whitespaces)
        .components(separatedBy: .whitespaces)
    //var linePartA = ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"]
    var linePartB = line.b.trimmingCharacters(in: .whitespaces)
        .components(separatedBy: .whitespaces)
    
    /// first pass
    for partialInputA in linePartA {
        
        let digit: SegmentCount = SegmentCount(digit: partialInputA)
        
        switch digit { // like .two segments
        case  .two:
            for entry in partialInputA.permutations() {
                dict[String(entry)] = "1"
            }
            print(partialInputA, " 1")
            linePartA.remove(element: partialInputA)
        case .three:
            for entry in partialInputA.permutations() {
                dict[String(entry)] = "7"
            }
            print(partialInputA, " 7")
            linePartA.remove(element: partialInputA)
            
        case .four:
            for entry in partialInputA.permutations() {
                dict[String(entry)] = "4"
            }
            print(partialInputA," 4")
            linePartA.remove(element: partialInputA)
        case .seven:
            for entry in partialInputA.permutations() {
                dict[String(entry)] = "8"
            }
            print(partialInputA, " 8")
            linePartA.remove(element: partialInputA)
        case .five, .six:
            break
        }
    }
    
    /// second pass
    for partialInputA in linePartA {
        let digit: SegmentCount = SegmentCount(digit: partialInputA)
        if digit == .five {
            print("five", partialInputA)
            if Set(partialInputA).isSuperset(of: Set(dict.keyFor(value: "1"))){
                print("3!")
                for entry in partialInputA.permutations() {
                    dict[String(entry)] = "3"
                }
                linePartA.remove(element: partialInputA)
            }
        }
    }
    
    /// het the remaining 5 and 2
    for partialInputA in linePartA {
        let digit: SegmentCount = SegmentCount(digit: partialInputA)
        if digit == .five {
            print("five", partialInputA)
            if Set(partialInputA).subtracting(Set(dict.keyFor(value: "3"))).isSubset(of: Set(dict.keyFor(value: "4"))) {
                print("5!")
                for entry in partialInputA.permutations() {
                    dict[String(entry)] = "5"
                }
                linePartA.remove(element: partialInputA)
            } else {
                print("2!")
                for entry in partialInputA.permutations() {
                    dict[String(entry)] = "2"
                }
                linePartA.remove(element: partialInputA)
            }
        }
    }
    
    /// het the remaining 9
    for partialInputA in linePartA {
        let digit: SegmentCount = SegmentCount(digit: partialInputA)
        if digit == .six {
            print("six", partialInputA)
            if Set(partialInputA) ==
                Set(dict.keyFor(value: "3")).union(Set(dict.keyFor(value: "5"))) {
                print("9!")
                for entry in partialInputA.permutations() {
                    dict[String(entry)] = "9"
                }
                linePartA.remove(element: partialInputA)
            }
        }
    }
    
    
    /// het the remaining 6 and 0
    for partialInputA in linePartA {
        let digit: SegmentCount = SegmentCount(digit: partialInputA)
        if digit == .six {
            print("six", partialInputA)
            if Set(partialInputA) == Set(dict.keyFor(value: "8")).subtracting(Set(dict.keyFor(value: "1"))).union( Set(dict.keyFor(value: "5")))   {
                print("6!")
                for entry in partialInputA.permutations() {
                    dict[String(entry)] = "6"
                }
                linePartA.remove(element: partialInputA)
            } else {
                print("0!")
                for entry in partialInputA.permutations() {
                    dict[String(entry)] = "0"
                }
                linePartA.remove(element: partialInputA)
            }
        }
    }
    
    
    var solution = 0
    var solutionString = ""
    dict["cdfeb"]
    for num in linePartB {
        print(dict[num])
        solutionString += dict[num] ?? ""
    }
    solutionTotal += Int(solutionString)!
}
solutionTotal
