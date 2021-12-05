//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

func day1() {
    let input: [Int] = getInputDay1()
    
    let solutionDay1a = input
        .adjacentPairs()
        .reduce(into: 0) {  total , pair  in
            total = (pair.0 < pair.1) ? total + 1 : total
        }
    print("Solution day1 - Part1:  \(solutionDay1a)")
    
    //    let solutionDay1a = input.adjacentPairs().reduce(0) { ($1.0 < $1.1) ? $0 + 1 : $0
    //    }
    //    print("Solution day1 - Part1:  \(solutionDay1a)")
    
    let solutionDay1b = input.windows(ofCount: 3)
        .map {$0.reduce(0,+)}
        .adjacentPairs()
        .reduce(into: 0) { partialResult, windowSums in
            partialResult = (windowSums.0 < windowSums.1) ? partialResult + 1 : partialResult
        }

    print("Solution day1 - Part1:  \(solutionDay1b)")
    
}




func getInputDay1() -> [Int] {
    var input: [Int] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .split(separator: "\n")
                    .compactMap { Int($0) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}
