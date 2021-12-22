//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

func day7() {
    let input: [Int] = getInputDay7()
    print(input)
    let max : Int = input.max()!

    var crabsDistribution: [Int] = Array(repeating: 0, count: max + 1)
    
    for crab in input {
        crabsDistribution[crab] += 1
    }

    var lowestFuelYet: Int?
    for index in 0..<crabsDistribution.count {
        let fuel = getTheFuelNeededFor(position: index, in: crabsDistribution)
        if let savedFuelValue = lowestFuelYet {
            if fuel < savedFuelValue {
                lowestFuelYet = fuel
            }
        } else {
            lowestFuelYet = fuel
        }
    }
    

    var solutionDay7a = lowestFuelYet
    var solutionDay7b = 0
    
    print("Solution day7 - Part1: \(solutionDay7a)")
    print("Solution day7 - Part2: \(solutionDay7b)")
}

func getTheFuelNeededFor(position: Int, in crabsDistribution: [Int]) -> Int {
    var fuel: Int = 0
    for (index,crabs) in crabsDistribution.enumerated() {
        fuel += crabs * fuelMultiplicator2(index: index, position: position)
        
    }
    print("position \(position) fuel \(fuel)")
    return fuel
}

func fuelMultiplicator1(index: Int, position: Int) -> Int {
abs(index - position)
}
func fuelMultiplicator2(index: Int, position: Int) -> Int {
    abs(index - position) * (abs(index - position) + 1 ) / 2
}

func getInputDay7() -> [Int] {
    var input: [Int] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-7", withExtension: "txt") {
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


