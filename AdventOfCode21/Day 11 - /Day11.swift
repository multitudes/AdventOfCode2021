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

    let rows: Int = input.count
    let cols: Int = input.first?.count ?? 0
    var flashingArray: Array<(i: Int, k: Int)> = []

    for i in 0..<rows {
        print("row \(i)", input[i])
    }
    
    for time in 0..<3 {
        for i in 0..<rows {
            for k in 0..<cols {
                print("power ",input[i][k])
                print("row \(i)", input[i])
                /// I got a 9 before incrementing - this will flash hard! 😀
                if input[i][k] == 9 {
                    let position: (i: Int, k:Int) = (i: i, k: k)
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
                        if input[newPos.i][newPos.k] == 9 {
                            
                            /// if so I need to check if it is already activated or if it is its first time getting activated -
                            if !flashingArray.contains(where: { tuple in
                                tuple.i == newPos.i && tuple.k == newPos.k
                            }) {
                                print("\(newPos) got a \(input[newPos.i][newPos.k]) not yet flashed")
                                /// first timer, needs to flash
                                flashingArray.append(newPos)
                                checkAllDirections(position: newPos, flashingArray:  &flashingArray )
                                
                                func checkAllDirections(position: (i: Int, k:Int),  flashingArray: inout Array<(i: Int, k: Int)> ) {
                                    for dir in directions {
                                        /// go in the direction adding or substracting 1 and get new pos
                                        let newPos = (i: (position.i + dir.i), k: (position.k + dir.k))
                                        ///check bounds for new pos
                                        if newPos.i >= rows ||  newPos.k >= cols || newPos.i < 0 || newPos.k < 0 { continue }
                                        
                                        /// check if I have a 9 already at new location -
                                        if input[newPos.i][newPos.k] == 9 {
                                            /// if so I need to check if it is already activated or if it is its first time getting activated -
                                            if !flashingArray.contains(where: { tuple in
                                                tuple.i == newPos.i && tuple.k == newPos.k
                                            }) {
                                                /// first timer, needs to flash
                                                flashingArray.append(newPos)
                                                checkAllDirections(position: newPos, flashingArray: &flashingArray)
                                            } else {
                                                /// this will be not flashing
                                                continue
                                            }
                                        } else {
                                            /// I did not have a 9 already
                                            /// add one energy to location
                                            /// if after that I reached a 9 it is ok - not ready to flash!
                                            input[newPos.i][newPos.k] = (input[newPos.i][newPos.k] + 1)
                                        }
                                    }
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
                            input[newPos.i][newPos.k] = (input[newPos.i][newPos.k] + 1)
                        }
                    }
                    /// finished going through the neighbours
                } else {
                    /// if I am here - because the octopus did not have a 9!
                    /// lets increase my energy
                    /// if after that I reached a 9 it is ok - not ready to flash!
                    input[i][k] = (input[i][k] + 1)
                }
            }
        }
        for pos in flashingArray {
            input[pos.i][pos.k] = 0
        }
        flashingArray = []
        for i in 0..<rows {
            print("row \(i)", input[i])
        }
        print("\n")
        print("\(time + 1) times")
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
        if let inputFileURL = bundle?.url(forResource: "input-11aa", withExtension: "txt") {
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
