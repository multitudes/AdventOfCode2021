//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation


/// I removed the newlines in file input-8a manually, as said on the website, it was only done on the example to format the text on the page but the puzzle input had no such things
func day8() {
    let input: [(a: String, b: String)] = getInputDay8()
    print(input)
    let solutionDay8a = input.map { $0.1 }
        .reduce(0) { (acc, val) in
            //print($1)
            let components = val // $1 was a string
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: .whitespaces)
            print(components) // - gets to be an array
            let partial = components.reduce(0) {
                print($1)
                if $1.count == 2 || $1.count == 3 || $1.count == 4 || $1.count == 7 {
                    return $0 + 1
                }
                return $0
            }
            print("partial \(partial)")
            return acc + partial
        }
    

    var solutionDay8b = 0
    
    print("Solution day8 - Part1: \(solutionDay8a)")
    print("Solution day8 - Part2: \(solutionDay8b)")
}


func getInputDay8() -> [(String,String)] {
    var input: [(String,String)] = [(a: "", b:"")]
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-8", withExtension: "txt") {
            let charSet = CharacterSet(charactersIn: "|")
            do {
                input = try String(contentsOf: inputFileURL)
                    .trimmingCharacters(in: .newlines)
                    .components(separatedBy: .newlines)
                
                    .map {
                        let splitString = $0.components(separatedBy: "|" )
                        print(splitString[0])
                        print(splitString[1])
                        let (a,b) : (a: String,b: String) = (a:splitString[0],b: splitString[1])
                        return (a:a,b:b)
                        }
              
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}


