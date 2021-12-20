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
    
    let bingoNumbers = input.numbers
    let boards = input.boards
    var solutionDay2a = 0
outerloop:for bingoNumber in bingoNumbers {
    print("BingoNumber ",bingoNumber )
    for board in boards {
        board.addNumber(bingoNumber)
        if board.winner {
            print("\nwinner")
            print(board.score)
            solutionDay2a = board.score
            break outerloop
        }
    }
    
    
}
    
    
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
                let notMarked = Set(allMyBoardNumbers).subtracting(row).subtracting(drawnNumbers)
                print("notMarked \(notMarked)")
                print("Array(notMarked).reduce(0, +) \(Array(notMarked).reduce(0, +)) * lastDrawnNumber \(lastDrawnNumber)")
                self.score = Array(notMarked).reduce(0, +) * lastDrawnNumber
                print("score \(score)")
                return true
            }
        }
        for col in columns {
            let a = Set(drawnNumbers).intersection(Set(col))
            if a.count == col.count {
                let notMarked = Set(allMyBoardNumbers).subtracting(col).subtracting(drawnNumbers)
                print("notMarked \(notMarked)")
                print("Array(notMarked).reduce(0, +) \(Array(notMarked).reduce(0, +)) * lastDrawnNumber \(lastDrawnNumber)")
                self.score = Array(notMarked).reduce(0, +) * lastDrawnNumber
                print("score \(score)")
                return true
            }
        }
        return false
    }
    var score : Int = 0
    
    init(string: String) {
        self.rows = string // 5 lines
            .components(separatedBy: "\n")
            .compactMap { row in // one string line with 5 numbers
                let r = row.components(separatedBy: .whitespaces).compactMap { Int($0)}
                if r.isEmpty { return nil } // the last one might just be empty!
                return r // array number
            }
        self.allMyBoardNumbers = Set(self.rows.flatMap {$0})
    }
    
    func addNumber(_ num: Int) {
        lastDrawnNumber = num
        drawnNumbers.append(num)
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
        if let inputFileURL = bundle?.url(forResource: "input-4", withExtension: "txt") {
            do {
                numbers = try String(contentsOf: inputFileURL)
                    .components(separatedBy: .newlines)
                    .prefix(1)
                    .flatMap({ $0.components(separatedBy: ",").compactMap { Int(String($0)) } })
                boards = try String(contentsOf: inputFileURL)
                    .components(separatedBy: "\n\n")
                    .dropFirst()
                    .map { Board(string: $0) }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return (numbers: numbers, boards: boards)
}
