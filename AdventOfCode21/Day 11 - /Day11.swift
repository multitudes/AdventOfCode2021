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
func day11() {
    var input: [String] = getInputDay11()

    let solutionDay11a = 0
    let solutionDay11b = 0
    print("Solution day11 - Part1: \(solutionDay11a)")
    print("Solution day11 - Part2: \(solutionDay11b)")
}


func getInputDay11() -> [String] {
    var input: [String] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-11a", withExtension: "txt") {
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
