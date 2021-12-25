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

/// I removed the newlines in file input-8a manually, as said on the website, it was only done on the example to format the text on the page but the puzzle input had no such things
func day11() {
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
    //var rangeRows: ClosedRange<Int> = 0...input.count - 1
    //var rangeOctopi: ClosedRange<Int> = 0...rowLength -1
    var input: [[Int]] = getInputDay11()
    var matrix = input
    let rows: Int = input.count
    let cols: Int = input.first?.count ?? 0
    var flashingArray: Array<(i: Int, k: Int)> = []
    var totalFlashes = 0
    
    for i in 0..<rows {
        print("row \(i)", input[i])
    }
    
    for time in 0..<1000 {
        for i in 0..<rows {
            for k in 0..<cols {
                print("power ",matrix[i][k])
                print("row \(i)", matrix[i])
                let position: (i: Int, k:Int) = (i: i, k: k)
                /// I got a 9 before incrementing - this will flash hard! 😀
                if matrix[i][k] == 9 && !flashingArray.contains(where: { tuple in
                    tuple.i == position.i && tuple.k == position.k
                }) {
                    print("flash at position \(position)")
                    /// it will not need to flash again!
                    flashingArray.append(position)
                    print("flashingArray append \(position)")
                    
                    /// add 1 to my fellow 🐙
                    for dir in directions {
                        print("going dir \(dir) ")
                        /// go in the direction adding or substracting 1 and get new pos
                        let newPos = (i: (position.i + dir.i), k: (position.k + dir.k))
                        ///check bounds for new pos
                        if newPos.i >= rows ||  newPos.k >= cols || newPos.i < 0 || newPos.k < 0 {
                            print("\(dir) out of bounds - continue")
                            continue }
                        
                        /// check if I have a 9 already at new location -
                        if matrix[newPos.i][newPos.k] == 9 {
                            
                            /// if so I need to check if it is already activated or if it is its first time getting activated -
                            if !flashingArray.contains(where: { tuple in
                                tuple.i == newPos.i && tuple.k == newPos.k
                            }) {
                                print("\(newPos) got a \(matrix[newPos.i][newPos.k]) not yet flashed")
                                /// first timer, needs to flash
                                flashingArray.append(newPos)
                                checkAllDirections(position: newPos, flashingArray:  &flashingArray, matrix: &matrix )
                                
                                func checkAllDirections(position: (i: Int, k:Int), flashingArray: inout Array<(i: Int, k: Int)>, matrix: inout [[Int]] ) {
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
            break
        }
        flashingArray = []
        print("\(time + 1) times - total \(totalFlashes)")
        print("\n ========= \n")
        for i in 0..<rows {
            print("row \(i)", matrix[i])
        }
        print("\n ========= \n\n")
    }
    let solutionDay11a = 0
    let solutionDay11b = 0
    print("Solution day11 - Part1: \(solutionDay11a)")
    print("Solution day11 - Part2: \(solutionDay11b)")
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
