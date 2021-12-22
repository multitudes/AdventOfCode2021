import UIKit
import CoreGraphics


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
            print("row", row)
            let a = Set(drawnNumbers).intersection(Set(row))
            a.count
            row.count
            if a.count == row.count {
                print("a.count == row.count",a.count, row.count)
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
            .compactMap { row in // one string line with 5 numbers
                let r = row.components(separatedBy: .whitespaces).compactMap { Int($0)}
                if r.isEmpty { return nil }
                return r // array number
        }
        self.allMyBoardNumbers = Set(self.rows.flatMap {$0})
    }
    
    func addNumber(_ num: Int) {
        lastDrawnNumber = num
        drawnNumbers.append(num)
    }
}


func getInputDay4() -> (numbers: [Int], boards: [Board]) {
    var numbers: [Int] = []
    var boards: [Board] = []
    
    do {
        if let inputFileURL = Bundle.main.url(forResource: "input-4a", withExtension: "txt") {
            do {
                numbers = try String(contentsOf: inputFileURL)
                    .components(separatedBy: .newlines)
                    .prefix(1)
                    .flatMap({ $0.components(separatedBy: ",").compactMap { Int(String($0)) } })
                boards = try String(contentsOf: inputFileURL)
                    .components(separatedBy: "\n\n")
                    .dropFirst()
                    .map { Board(string: $0) }
                //dump(boards.first!.columns)
                //dump(numbers)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return (numbers: numbers, boards: boards)
}

let input:(numbers: [Int], boards: [Board]) = getInputDay4()

let bingoNumbers =  [7]//input.numbers
let boards = input.boards

for bingoNumber in bingoNumbers {
    print("BingoNumber ",bingoNumber )
    for board in boards {
        print(boards)
        board.addNumber(bingoNumber)
        if board.winner {
            print("\nwinner")
            print(board.score)
        }
    }
    
    
}
let solutionDay2a = 0
print("Solution day2 - Part1: \(solutionDay2a)")

let solutionDay2b = 0

print("Solution day2 - Part2: \(solutionDay2b)")
