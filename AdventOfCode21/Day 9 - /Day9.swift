//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation



/// I removed the newlines in file input-8a manually, as said on the website, it was only done on the example to format the text on the page but the puzzle input had no such things
func day9() {
    let input: [String] = getInputDay9()
    
    print(input)
    /// part 1!
    ///
    ///create padding all around our matrox with 9's
    let digitsInRow = input.first!.count
    let firstAndLastRow: [Int] = Array(repeating: "9", count: digitsInRow + 2).compactMap { Int($0)    }
    var matrix: [[Int]] = [firstAndLastRow]

    for i in 0..<input.count {
        var row: [Int] = input[i].compactMap { Int(String($0)) }
        row.insert(9, at: 0)
        row.append(9)
        matrix.append(row)
    }
    matrix.append(firstAndLastRow)
    
    // check the adjacent and look for lowest
    for i in
    
    
    
    
    let solutionDay9a = 0
    var solutionDay9b = 0
    
    print("Solution day9 - Part1: \(solutionDay9a)")
    print("Solution day9 - Part2: \(solutionDay9b)")
}


func getInputDay9() -> [String] {
    var input: [String] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-9a", withExtension: "txt") {
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
