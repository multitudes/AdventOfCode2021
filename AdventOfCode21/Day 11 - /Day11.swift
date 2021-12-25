//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

let directions: [(i: Int, k: Int)] = [
    (i: 0, k: 1),
    (i: 1, k: 1),
    (i: 1, k: 0),
    (i: 1, k: -1),
    (i: 0, k: -1),
    (i: -1, k: -1),
    (i: -1, k: 0),
    (i: -1, k: 1)
]

/// I removed the newlines in file input-8a manually, as said on the website, it was only done on the example to format the text on the page but the puzzle input had no such things
func day11() {
   
    //var rangeRows: ClosedRange<Int> = 0...input.count - 1
    //var rangeOctopi: ClosedRange<Int> = 0...rowLength -1
    let input: [[Int]] = getInputDay11()
    /// I am not sure but I had race conditions without doing a copy
    var matrix = input
    /// convenience
    let rows: Int = input.count
    let cols: Int = input.first?.count ?? 0
    /// most important array
    var flashingArray: Array<(i: Int, k: Int)> = []
    var totalFlashes = 0
    
    /// for part 1 I need a 100 times loop - for part two I need a while loop , but decided 1000 was enough. I break earlier with the solution
    for time in 0..<1000 {
        for i in 0..<rows {
            for k in 0..<cols {
                let position: (i: Int, k:Int) = (i: i, k: k)
                /// I got a 9 before incrementing - this will flash hard! 😀 - of course (!) I check if the octopus already flashed before :))
                if matrix[i][k] == 9 &&
                    !flashingArray.contains(where: { tuple in
                    tuple.i == position.i && tuple.k == position.k }) {
                    /// keep track of the octopus, it will not need to flash again!
                    flashingArray.append(position)
                    /// add 1 power to my fellow 🐙s
                    for dir in directions {
                        /// go in the direction adding or substracting 1 and get new pos
                        let newPos = (i: (position.i + dir.i), k: (position.k + dir.k))
                        ///check bounds for new pos
                        if newPos.i >= rows ||  newPos.k >= cols || newPos.i < 0 || newPos.k < 0 { continue }
                        /// check if I have a 9 already at new location -
                        if matrix[newPos.i][newPos.k] == 9 {
                            /// if so I need to check if it is already activated or if it is its first time getting activated -
                            if !flashingArray.contains(where: { tuple in
                                tuple.i == newPos.i && tuple.k == newPos.k
                            }) {
                                /// first timer, needs to flash
                                flashingArray.append(newPos)
                                /// bit of recursion!
                                checkAllDirections(position: newPos, flashingArray:  &flashingArray, matrix: &matrix )
                            } else {
                                /// it is a 9  but already flashed - this will be not flashing again
                                /// continue to next direcrion
                                continue
                            }
                        } else {
                            /// I did not have a 9 already
                            /// add one energy to location
                            /// if after that I reached a 9 it is ok - not ready to flash yet!
                            matrix[newPos.i][newPos.k] = (matrix[newPos.i][newPos.k] + 1)
                        }
                    }
                    /// finished going through the neighbours
                } else {
                    /// if I am here - because the octopus did not have a 9!
                    /// lets increase my energy
                    /// if after that I reached a 9 it is ok - not ready to flash!
                    matrix[i][k] = (matrix[i][k] + 1)
                }
            }
        }
        for pos in flashingArray {
            matrix[pos.i][pos.k] = 0
        }
        totalFlashes += flashingArray.count
        if flashingArray.count == 100 {
            print("synchronicity@@@@@@")
            print("\(time + 1) times - total \(totalFlashes)")
            print("Solution day11 - Part2: \(time + 1)")
            break
        }
        flashingArray = []
        if time + 1 == 100 {
            print("Solution day11 - Part1: \(totalFlashes)")
        }
//        print("\(time + 1) times - total \(totalFlashes)")
//        print("\n ========= \n")
//        for i in 0..<rows {
//            print("row \(i)", matrix[i])
//        }
//        print("\n ========= \n\n")
    }

    
    
}

func checkAllDirections(position: (i: Int, k:Int), flashingArray: inout Array<(i: Int, k: Int)>, matrix: inout [[Int]] ) {
    let rows: Int = matrix.count
    let cols: Int = matrix.first?.count ?? 0
    for dir in directions {
        /// go in the direction adding or substracting 1 and get new pos
        let newPos = (i: (position.i + dir.i), k: (position.k + dir.k))
        ///check bounds for new pos
        if newPos.i >= rows ||  newPos.k >= cols || newPos.i < 0 || newPos.k < 0 { continue }
        /// check if I have a 9 already at new location -
        if matrix[newPos.i][newPos.k] == 9 {
            /// if so I need to check if it is already activated or if it is its first time getting activated -
            if !flashingArray.contains(where: { tuple in
                tuple.i == newPos.i && tuple.k == newPos.k
            }) {
                /// first timer, needs to flash
                flashingArray.append(newPos)
                checkAllDirections(position: newPos, flashingArray: &flashingArray, matrix: &matrix)
            } else {
                /// this will be not flashing
                continue
            }
        } else {
            /// I did not have a 9 already
            /// add one energy to location
            /// if after that I reached a 9 it is ok - not ready to flash!
            matrix[newPos.i][newPos.k] = (matrix[newPos.i][newPos.k] + 1)
        }
    }
    return
}

func getInputDay11() -> [[Int]] {
    var input: [[Int]] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-11", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .trimmingCharacters(in: .newlines)
                    .components(separatedBy: .newlines)
                    .map {
                        let arr = Array($0).compactMap {  Int(String($0)) }
                        return arr }
                   
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}
