//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation



func day2() {
    let input: [(command: SubmarineCommand, amount: Int)] = getInputDay2()

    let solutionDay2a = input.reduce(Position()) { position, course in
        switch course.command {
        case .forward:
            return position.increaseForward(horizontal: course.amount)
        case .down:
            return position.increaseDepth(depth: course.amount)
        case .up:
            return position.decreaseDepth(depth: course.amount)
        }
    }.currentPositionResult
    print("Solution day2 - Part1: \(solutionDay2a)")
    
    
    
    
    
    
    
    
    
    print("Solution day2 - Part2: \(solutionDay2a)")
}



func getInputDay2() -> [(command: SubmarineCommand, amount: Int)] {
    var input: [(SubmarineCommand, Int)] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-2", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .split(separator: "\n")
                    .map {
                        /// I should have just two elements per row, the command and amount
                        let ab = $0.components(separatedBy: .whitespaces)
                        /// error handling
                        guard let command = ab.first, let a =  SubmarineCommand.init(rawValue: command) else {
                            throw InputError.invalidInput
                        }
                        guard let amount = ab.last, let b = Int(amount) else {
                            throw InputError.invalidInput
                        }
                        return (command: a, amount: b)
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}



enum SubmarineCommand: String {
    case forward
    case down
    case up
}


struct Position {
    var depth: Int
    var horizontal: Int
    var aim: Int
    
    /// this always inits at the zero position
    init() { depth = 0; horizontal = 0; aim = 0 }
}

extension Position {
    /// I use a struct so I will internally recreate a new one instead of changing the exixting one
    private init(depth: Int, horizontal: Int, aim: Int = 0) {
        self.depth = depth
        self.horizontal = horizontal
        self.aim = aim
    }
    
    func increaseDepth(depth: Int) -> Position {
        let newdepth = self.depth + depth
        return Position(depth: newdepth, horizontal: self.horizontal)
    }
    
    func increaseForward(horizontal: Int) -> Position {
        let newHorizontal = self.horizontal + horizontal
        return Position(depth: self.depth, horizontal: newHorizontal)
    }
    
    func decreaseDepth(depth: Int) -> Position {
        let newdepth = self.depth - depth
        return Position(depth: newdepth, horizontal: self.horizontal)

    }
    
    /// this is for part 2
    
    func increaseAim(aim: Int) -> Position {
        let newAim = self.aim + aim
        return Position(depth: self.depth, horizontal: self.horizontal, aim: newAim)
    }
    
    func increaseForwardWithAim(units: Int) -> Position {
        let newHorizontal = self.horizontal + horizontal
        let newdepth = self.depth + (self.aim * units)
        return Position(depth: newdepth, horizontal: newHorizontal, aim: self.aim)
    }
    
    func decreaseAim(aim: Int) -> Position {
        let newAim = self.aim - aim
        return Position(depth: self.depth, horizontal: self.horizontal, aim: newAim)

    }
    
    
    var currentPositionResult: Int {
        depth * horizontal
    }
}


enum InputError: Error {
    case invalidInput
    case readingError(String)
}

