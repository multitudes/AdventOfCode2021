//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Algorithms
import Foundation

func day4() {
    let input:(numbers: [Int], boards: [Board]) = getInputDay4()
 
    let solutionDay2a = 0
    print("Solution day2 - Part1: \(solutionDay2a)")

    
    let solutionDay2b = 0
    
    print("Solution day2 - Part2: \(solutionDay2b)")
}

/// I assume a bingo biard will be like in both example and challenge 5 x 5
class Board {
    var rows: [[Int]]
    var columns: [[Int]] {
        var cols: [[Int]] = []
        for i in 0...4 {
            let col = rows[column: i]
            cols.append(col)
        }
        return cols
    }
    var allMyBoardNumbers: Set<Int>
    var drawnNumbers: [Int] = []
    var lastDrawnNumber: Int = -1
    var winner: Bool {
        for row in rows {
            let a = Set(drawnNumbers).intersection(Set(row))
            if a.count == row.count {
                let notMarked = Set(allMyBoardNumbers).subtracting(row)
                self.score = Array(notMarked).reduce(0, +) * lastDrawnNumber
                return true
            }
        }
        for col in columns {
            let a = Set(drawnNumbers).intersection(Set(col))
            if a.count == col.count {
                let notMarked = Set(allMyBoardNumbers).subtracting(col)
                self.score = Array(notMarked).reduce(0, +) * lastDrawnNumber
                return true
            }
        }
        return false
    }
    var score : Int = 0
    
    init(string: String) {
        self.rows = string // 5 lines
            .components(separatedBy: "\n")
            .map { row in // one string line with 5 numbers
                return row.components(separatedBy: .whitespaces).compactMap { Int($0)} // array number
        }
        self.allMyBoardNumbers = Set(self.rows.flatMap {$0})
    }
}


extension Array where Element : Collection {
    func getColumn(column : Element.Index) -> [ Element.Iterator.Element ] {
        return self.map { $0[ column ] }
    }
}
extension Array where Element : Collection {
    subscript(column column : Element.Index) -> [ Element.Iterator.Element ] {
        return map { $0[ column ] }
    }
}
func getInputDay4() -> (numbers: [Int], boards: [Board]) {
    var numbers: [Int] = []
    var boards: [Board] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-4a", withExtension: "txt") {
            do {
                numbers = try String(contentsOf: inputFileURL)
                    .split(separator: "\n")
                    .prefix(1)
                    .compactMap { Int(String($0)) }
                let boards: [Board] = try String(contentsOf: inputFileURL)
                    .components(separatedBy: "\n\n")
                    .dropFirst()
                    .map { Board(string: $0) }
                dump(boards.first!.columns)

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return (numbers: [], boards: [])
}
