//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//


import Foundation

func day4() {
    var (bingoNumbers, boards) = getInputDay4()
    var solutionDay2a: Int? = nil
    var solutionDay2b = 0
    for bingoNumber in bingoNumbers {
        for board in boards {
            board.addNumber(bingoNumber)
            if board.winner {
                /// to be set only once
                if solutionDay2a == nil {
                    solutionDay2a = board.score
                }
                /// it will be set multiple times - I will keep the last!
                solutionDay2b = board.score
                /// boards will get less and less - the winning are removed- looking for the last winning board!
                if let index = boards.firstIndex(of: board) {
                    boards.remove(at: index)
                }
            }
        }
    }
    print("Solution day2 - Part1: \(solutionDay2a ?? 0)")
    print("Solution day2 - Part2: \(solutionDay2b)")
}

/// I assume a bingo biard will be like in both example and challenge 5 x 5
class Board: Equatable {
    let id = UUID()
    /// conformance to equatable
    static func == (lhs: Board, rhs: Board) -> Bool {lhs.id == rhs.id}
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
            if checkIfRowOrColumnIsWinning(numbers: row) { return true}
        }
        for col in columns {
            if checkIfRowOrColumnIsWinning(numbers: col) { return true}
        }
        /// no winner yet
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
    
    func checkIfRowOrColumnIsWinning(numbers: [Int]) -> Bool {
        let a = Set(drawnNumbers).intersection(Set(numbers))
        if a.count == 5 {
            print(a)
            let notMarked = Set(allMyBoardNumbers).subtracting(numbers).subtracting(drawnNumbers)
            print("notMarked \(notMarked)")
            print("Array(notMarked).reduce(0, +) \(Array(notMarked).reduce(0, +)) * lastDrawnNumber \(lastDrawnNumber)")
            self.score = Array(notMarked).reduce(0, +) * lastDrawnNumber
            print("score \(score)")
            return true
        }
        return false
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
