//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

let input = [16,1,2,0,4,2,7,1,2,14]
//let input = [1,2,0,2]
let (min, max) : (Int,Int) = (input.min()!, input.max()!)
min
max
var crabsDistribution: [Int] = Array(repeating: 0, count: max + 1)
for crab in input {
    crabsDistribution[crab] += 1
}
crabsDistribution

func getTheFuelNeededFor(position: Int) -> Int {
    var fuel: Int = 0
    for (i,crabs) in crabsDistribution.enumerated() {
        fuel += crabs * abs(i - position)
    }
    print("position \(position) fuel \(fuel)")
    return fuel
}

var lowestFuelYet: Int?
for index in 0..<crabsDistribution.count {
    let fuel = getTheFuelNeededFor(position: index)
    if let savedFuelValue = lowestFuelYet {
        if fuel < savedFuelValue {
            lowestFuelYet = fuel
        }
    } else {
        lowestFuelYet = fuel
    }
}
lowestFuelYet
