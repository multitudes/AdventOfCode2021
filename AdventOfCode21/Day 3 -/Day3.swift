//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

public enum Rating {
    case oxygen, co2
    public init() {
        self = .oxygen
    }
}


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
    for bitNumber in stride(from: numberOfBits, to: 0, by: -1) {
        /// `loopOn()` returns two arrays of strings, the one that passed the test to have a one at the bitnumber position and the ones with the zeroes for each bit number position passed down in the for loop
        let (ones, zeroes) = loopOn(array: input, bitNumber: bitNumber)
        /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
        if ones.count > zeroes.count {
            /// again bitwise operations here. I am still using my stride as comparing the bit positions,
            /// so if i = 5, this means 10000, and 2 << (5 - 2) is 10000
            gammaRate += (2 << (bitNumber - 2))
        } else {
            epsilonRate += (2 << (bitNumber - 2))
        }
    }
    
    powerConsumption = gammaRate * epsilonRate
    let solutionDay2a = powerConsumption
    print("Solution day2 - Part1: \(solutionDay2a)")
    
    /// Next, you should verify the life support rating, which can be determined by multiplying the oxygen generator rating by the CO2 scrubber rating.
    
    /// this will be my solution
    var lifeSupportRating = 0
    /// optional because converting a string to int will be always an optional anyway
    var oxygenGeneratorRating: Int? = nil
    var co2ScrubberRating: Int? = nil
    /// initialize my arrays to loop on - at the beginning they will have both my input
    var oxygenGeneratorRatingArray: [String] = input
    var co2ScrubberRatingArray: [String] = input
    
    
    for bitNumber in stride(from: numberOfBits, to: 0, by: -1) {
        /// I only update my array if it is not empty - I might have the solution already for the other array but not for all
        if !oxygenGeneratorRatingArray.isEmpty {
            oxygenGeneratorRatingArray = updateRatingsArray(inputArray: oxygenGeneratorRatingArray, for: .oxygen, bitNumber: bitNumber)}
        /// Here i have a solution and I update my property with a value
        if oxygenGeneratorRatingArray.count == 1 {
            oxygenGeneratorRating = Int(oxygenGeneratorRatingArray[0], radix: 2 )
        }
        /// I only update my array if it is not empty
        if !co2ScrubberRatingArray.isEmpty {
            co2ScrubberRatingArray = updateRatingsArray(inputArray: co2ScrubberRatingArray, for: .co2, bitNumber: bitNumber)}
        /// Here i have a solution and I update my property with a value
        if co2ScrubberRatingArray.count == 1 {
            co2ScrubberRating = Int(co2ScrubberRatingArray[0], radix: 2)
        }
        /// if they are both non nil... then I can break
        if let oxygenGeneratorRating = oxygenGeneratorRating,
           let co2ScrubberRating = co2ScrubberRating {
            lifeSupportRating = oxygenGeneratorRating * co2ScrubberRating
            break
        }
    }
    
    let solutionDay2b = lifeSupportRating
    
    print("Solution day2 - Part2: \(solutionDay2b)")
}


func getInputDay3() -> [String] {
    var input: [String] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-3", withExtension: "txt") {
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


func loopOn(array input: [String], bitNumber: Int) -> (ones: [String], zeroes: [String]) {
    /// initialise my counts
    var onesArray: [String] = []; var zeroesArray: [String] = []
    /// looping on the inputs
    for binary in input {
        /// my binary input transformed from string to Int
        let binaryInt = UInt(binary, radix: 2)!
        
        /// I do a logic AND between my binary and the current bit like
        /// ex binary is 11011 and my i is 5 I will compare the two:
        /// 11011 & 10000 which will give 10000 = 16
        /// I look only for zeroes first ... because practical
        if (binaryInt & (2 << (bitNumber - 2))) == 0 {
            zeroesArray.append(binary)
        } else {
            onesArray.append(binary)
        }
    }
    return (onesArray, zeroesArray)
}


func updateRatingsArray(inputArray input: [String], for rating: Rating, bitNumber: Int) -> [String] {
    
    let (onesArray, zeroesArray) = loopOn(array: input, bitNumber: bitNumber)
    
    switch rating {
    case .oxygen:
        /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
        if onesArray.count >= zeroesArray.count {
            /// again bitwise operations here. I am still using my stride as comparing the bit positions,
            /// so if i = 5, this means 10000, and 2 << (5 - 2) is 10000
            print("oxygenGeneratorRatingArray ones are more - bit nr \(bitNumber) \(onesArray)")
            return onesArray
        } else {
            print("oxygenGeneratorRatingArray zeroes are more - bit nr \(bitNumber) \(onesArray)")
            return zeroesArray
        }
    case .co2:
        /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
        if zeroesArray.count <= onesArray.count   {
            /// again bitwise operations here. I am still using my stride as comparing the bit positions,
            /// so if i = 5, this means 10000, and 2 << (5 - 2) is 10000
            print("co2ScrubberRatingArray zeroes are more - bit nr \(bitNumber) \(zeroesArray)")
            return zeroesArray
        } else {
            print("co2ScrubberRatingArray zeroes are less - bit nr \(bitNumber) \(onesArray)")
            return onesArray
        }
    }
}
