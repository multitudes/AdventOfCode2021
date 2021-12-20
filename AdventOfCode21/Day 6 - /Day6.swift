//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

func day6() {
    let input: [Int] = getInputDay6()
    print(input)
    
    let solutionDay6a = 0
    print("Solution day2 - Part1: \(solutionDay6a)")

    
    let solutionDay6b = 0
    
    print("Solution day2 - Part2: \(solutionDay6b)")
}


func getInputDay6() -> [Int] {
    var input: [Int] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-6a", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .components(separatedBy: ",")
                    .compactMap {
                        Int($0)
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}
