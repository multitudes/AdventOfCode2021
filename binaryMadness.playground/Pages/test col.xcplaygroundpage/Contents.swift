//: [Previous](@previous)

import Foundation


extension Array where Element : Collection {
    subscript(column column : Element.Index) -> [ Element.Iterator.Element ] {
        return map { $0[ column ] }
    }
}


let rows = [[22, 13, 17, 11, 0], [8, 2, 23, 4, 24], [21, 9, 14, 16, 7], [6, 10, 3, 18, 5], [1, 12, 20, 15, 19]]

var cols: [[Int]] = []
for i in 0...4 {
    let col = rows[column: i]
    cols.append(col)
}
print(cols)

let allMyBoardNumbers = Set(rows.flatMap {$0})

