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
    
    var solutionDay6a = 0
    var solutionDay6b = 0
    
    let glowingLanternfishesSchool = Spawn(seed: input )

    for (index, spawn) in glowingLanternfishesSchool.enumerated() {
        if index == 79 {
            solutionDay6a = spawn.kindergarden.reduce(0,+) + spawn.teens.reduce(0,+)
        }
        if index == 255 {
            solutionDay6b = spawn.kindergarden.reduce(0,+) + spawn.teens.reduce(0,+)
        }
    }
    print("Solution day6 - Part1: \(solutionDay6a)")
    print("Solution day6 - Part2: \(solutionDay6b)")
}

struct Spawn: Sequence {
    let seed: [Int]
    
    func makeIterator() -> SpawnIterator {
        return SpawnIterator(self)
    }
}
struct SpawnIterator: IteratorProtocol {
    var times = 256
    /// reserving place
    var week: [Int]
    var kindergarden: [Int] = []
    
    var readyToSpawn: Int = 0
    var teens: Int = 0 // the fishes that graduate from kindergarden
    
    init(_ spawn: Spawn) {
        week = Array(repeating: 0, count: 7)
        kindergarden = Array(repeating: 0, count: 3)
        /// init my week array transferring the values from
        for timeLeftToSpawn in spawn.seed { week[timeLeftToSpawn] += 1 }
    }
    
    /// lets return a tuple, because at the end I need to count all fishes in both arrays
    mutating func next() -> (kindergarden: [Int], teens: [Int])? {
        defer { times -= 1 }
        guard times > 0 else { return nil }
        /// here the order matters a lot!
        readyToSpawn = week[0]
        kindergarden = kindergarden.shiftRight()
        week = week.shiftRight()
        kindergarden[2] = readyToSpawn
        /// check if someone finished kindergarden
        teens = kindergarden[0]
        /// if so merge with the other fishes at day 6
        week[6] = week[6] + teens
        /// and reset because they do not want to be shifted back to kindergarden day -2
        kindergarden[0] = 0
        return (kindergarden, week)
    }
}

func getInputDay6() -> [Int] {
    var input: [Int] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-6", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .trimmingCharacters(in: .newlines)
                    .components(separatedBy: .punctuationCharacters )
                    .compactMap { Int($0) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}



extension Array {
    func shiftRight(_ amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }

    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}
