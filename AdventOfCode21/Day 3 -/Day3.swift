//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

struct DiagnosticReport {
    var gammaRate: Int
    var epsilonRate: Int
    var powerConsumption: Int
    
    /// this always inits at the zero position
    init() { gammaRate = 0; epsilonRate = 0; powerConsumption = 0 }
}

extension DiagnosticReport {
    /// I use a struct so I will internally recreate a new one instead of changing the exixting one
    private init(gammaRate: Int, epsilonRate: Int, powerConsumption: Int) {
        self.gammaRate = gammaRate
        self.epsilonRate = epsilonRate
        self.powerConsumption = powerConsumption
    }
    
    func setNewValues(gammaRate: Int, epsilonRate: Int, powerConsumption: Int) -> DiagnosticReport {
        return DiagnosticReport(gammaRate: gammaRate, epsilonRate: self.epsilonRate, powerConsumption: self.powerConsumption)
    }
}
//diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). The power consumption can then be found by multiplying the gamma rate by the epsilon rate.
//  r = Int((hexNumber & 0xff000000) >> 24)


func day3() {
    let input: [String] = getInputDay3()
    
    /// How many bits I got per input assuming that they are all the same?
    let numberOfBits: Int = {
        if let count = input.first?.count {
            return count
        } else { return 0 }
    }()

    /// Used to solve the quiz
    var gammaRate: UInt = 0
    var epsilonRate: UInt = 0
    var powerConsumption: UInt = 0

    /// bitwise operation - If I have 5 bits I will start from 5, then 4 ... till one
    for i in stride(from: numberOfBits, to: 0, by: -1) {
        /// initialise my counts
        var ones = 0; var zeroes = 0
        /// looping on the inputs
        for binary in input {
            /// my binary input transformed from string to Int
            let binaryInt = UInt(binary, radix: 2)!
            /// I do a logic AND between my binary and the current bit like
            /// ex binary is 11011 and my i is 5 I will compare the two:
            /// 11011 & 10000 which will give 10000 = 16
            /// I look only for zeroes first ... because practical
            if (binaryInt & (2 << (i - 2))) == 0 {
                zeroes += 1
            } else {
                ones += 1
            }
        }
        /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
        if ones > zeroes {
            /// again bitwise operations here. I am still using my stride as comparing the bit positions,
            /// so if i = 5, this means 10000, and 2 << (5 - 2) is 10000
            gammaRate += (2 << (i - 2))
        } else {
            epsilonRate += (2 << (i - 2))
        }
    }
    powerConsumption = gammaRate * epsilonRate
    let solutionDay2a = powerConsumption
    print("Solution day2 - Part1: \(solutionDay2a)")
    
    let solutionDay2b = 0
    
    print("Solution day2 - Part2: \(solutionDay2b)")
}


func getInputDay3() -> [String] {
    var input: [String] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-3a", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .split(separator: "\n")
                    .map {
                       print(String($0))
                        return String($0)
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}


infix operator **
func **<I: BinaryInteger>(lhs: I, rhs: I) -> I {
    return I(pow(Double(lhs), Double(rhs)))
}
