//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

func day8() {
    let input: [Int] = getInputDay8()
    print(input)
    
    
    
    var solutionDay8a = 0
    var solutionDay8b = 0
    
    print("Solution day8 - Part1: \(solutionDay8a)")
    print("Solution day8 - Part2: \(solutionDay8b)")
}


func getInputDay8() -> [Int] {
    var input: [Int] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-8a", withExtension: "txt") {
            let charSet = CharacterSet(charactersIn: "|")
            do {
                input = try String(contentsOf: inputFileURL)
                    .components(separatedBy: .newlines )
                    .map {
                        print("===")
                        print($0)
                      //  print($0.trimmingCharacters(in: charSet))
                        //.getTrimmedCapturedGroupsFrom(regexPattern: "(\\d+),(\\d+) -> (\\d+),(\\d+)") ?? []
                       return 0 }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}


