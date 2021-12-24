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
    let firstAndLastRow: [Int] = Array(repeating: "9", count: digitsInRow + 2).compactMap { Int($0) }
    var matrix: [[Int]] = [firstAndLastRow]
    print(matrix[0])
    for i in 0..<input.count {
        var row: [Int] = input[i].compactMap { Int(String($0)) }
        row.insert(9, at: 0)
        row.append(9)
        matrix.append(row)
    }
    matrix.append(firstAndLastRow)
    var lowPoints: [Int] = []
    var basins: [Int] = []
    /// after having my input padded with 9's I check the adjacent and look for lowest
    for i in 1..<input.count + 1 {
        for k in 1..<digitsInRow + 1 {
            print("\(i) \(k) \(matrix[i].map({String($0)}).joined())")
            // check the four directions
            if matrix[i][k] < matrix[i-1][k] &&
                matrix[i][k] < matrix[i][k-1] &&
                matrix[i][k] < matrix[i][k+1] &&
                matrix[i][k] < matrix[i+1][k]
            {
                print("low point! \(matrix[i][k])")
                /// This for part one of the challenge
                lowPoints.append(matrix[i][k])

                let size = getNextLowRecursive(matrix: &matrix, i: i, k: k)
                
                func getNextLowRecursive(matrix: inout [[Int]], i: Int, k: Int) -> Int {
                    /// this is our escape from looping to death
                    if matrix[i][k] == 9 { return 0 }
                    /// put myself to 9 - already visited
                    matrix[i][k] = 9
                    ///explore the other lows adding 1 because I had just one low
                    return 1 +
                    getNextLowRecursive(matrix: &matrix, i: i - 1, k: k) +
                    getNextLowRecursive(matrix: &matrix, i: i, k: k - 1) +
                    getNextLowRecursive(matrix: &matrix, i: i, k: k + 1) +
                    getNextLowRecursive(matrix: &matrix, i: i + 1, k: k)
                }
            basins.append(size)
        }
    }
}

let solutionDay9a = lowPoints.reduce(0) { $0 + $1 + 1 }
let solutionDay9b = basins.sorted(){ $0 > $1 }.prefix(3).reduce(1, *)

print("Solution day9 - Part1: \(solutionDay9a)")
print("Solution day9 - Part2: \(solutionDay9b)")
}


func getInputDay9() -> [String] {
    var input: [String] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-9", withExtension: "txt") {
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
