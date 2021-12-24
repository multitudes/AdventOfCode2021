//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

/* score
 ): 3 points.
 ]: 57 points.
 }: 1197 points.
 >: 25137 points.
 */

/// I removed the newlines in file input-8a manually, as said on the website, it was only done on the example to format the text on the page but the puzzle input had no such things
func day10() {
    var input: [String] = getInputDay10()

    let illegalCharDict: [Character: Int] = [
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137
    ]
    
    let autocompleteScores: [Character: Int] = [
        ")": 1,
        "]": 2,
        "}": 3,
        ">": 4
    ]
    
    let closingCharacterDict: [Character: Character] = [
        "(": ")",
        "[": "]",
        "{": "}",
        "<": ">"
    ]
    
    var totalScoresArray: [Int] = []
    
    let keys: Set<Character> = ["(", "[", "{", "<"]
    //var bracketDict: [Character : Int] = [:]
    var points: Int = 0
    var cumulativeStack: [Character] = []
    
    outer:for row in input {
        print(row)
        cumulativeStack = []
        for char in row {
            /// check if opening bracket
            if keys.contains(char) {
                //bracketDict[char, default: 0] += 1
                cumulativeStack.append(char)
                print(cumulativeStack)
            } else {
                /// it has to be a closing one
                if let lastBracket = cumulativeStack.last {
                    switch char {
                    case ")":
                        if lastBracket != "(" {
                            points += illegalCharDict[char, default: 0]
                            input.remove(element: row)
                            //print("\ncorrupted \(row) \n")
                            continue outer// to next row
                        } else {
                            _ = cumulativeStack.popLast()
                        }
                    case "}":
                        if lastBracket != "{" {
                            points += illegalCharDict[char, default: 0]
                            input.remove(element: row)
                            //print("\ncorrupted \(row) \n")
                            continue outer// to next row
                        } else {
                            _ = cumulativeStack.popLast()
                        }
                    case "]":
                        if lastBracket != "[" {
                            points += illegalCharDict[char, default: 0]
                            input.remove(element: row)
                            //print("\ncorrupted \(row) \n")
                            continue outer // to next row
                        } else {
                            _ = cumulativeStack.popLast()
                        }
                    case ">":
                        if lastBracket != "<" {
                            points += illegalCharDict[char, default: 0]
                            input.remove(element: row)
                            //print("\ncorrupted \(row) \n")
                            continue outer // to next row
                        } else {
                            _ = cumulativeStack.popLast()
                        }
                    default:
                        print("not expected this \(char)")
                    }
                } else {
                print("illegal char")
                }
            }
        }
        /// here I can deal with the autocomplete
//        print("cumulativeStack \(cumulativeStack)\n")
//        print("\nincomplete \(row) \n")
        var autocompleteArray: [Character] = []
        while !cumulativeStack.isEmpty {
            if let last = cumulativeStack.popLast() {
                autocompleteArray.append(closingCharacterDict[last, default: Character("")])
            }
        }
        print("\nautocomplete \(autocompleteArray) \n")
        
        /// calculate score for row
        var score = 0
        for char in autocompleteArray {
            score *= 5
            score += autocompleteScores[char, default: 0]
        }
        totalScoresArray.append(score)
    }
    totalScoresArray = totalScoresArray.sorted()

    let solutionDay10a = points
    let solutionDay10b = totalScoresArray[Int(totalScoresArray.count / 2)]
    print("Solution day9 - Part1: \(solutionDay10a)")
    print("Solution day9 - Part2: \(solutionDay10b)")
}


func getInputDay10() -> [String] {
    var input: [String] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-10", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .trimmingCharacters(in: .newlines)
                    .components(separatedBy: .newlines)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}
