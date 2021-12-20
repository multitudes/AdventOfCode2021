//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

func day4() {
    let input: [String] = getInputDay4()
 
    let solutionDay2a = 0
    print("Solution day2 - Part1: \(solutionDay2a)")

    
    let solutionDay2b = 0
    
    print("Solution day2 - Part2: \(solutionDay2b)")
}


func getInputDay4() -> [String] {
    var input: [String] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-5", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .split(separator: "\n")
                    .map {
                       String($0)
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}
