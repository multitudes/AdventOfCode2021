//: [Previous](@previous)

import Foundation

/// my input
let seed: [Int] = [3,4,3,1,2]
//let seed: [Int] = [3]

/// reserving place
var week: [Int] = Array(repeating: 0, count: 7)
var kindergarden: [Int] = Array(repeating: 0, count: 3)
/// init
for day in seed {
     week[day] += 1
}
week
kindergarden
var readyToSpawn = 0
var adults = 0

/// one day
/// check the ready to spawn at psition 0 -
///  add them to kindergarten
/// I shift the kindergarden and week by one
///
/// day 0

readyToSpawn = week[0]
kindergarden[2] = readyToSpawn


/// day 1

readyToSpawn = week[0]
kindergarden = kindergarden.shiftRight()
week = week.shiftRight()
kindergarden[2] = readyToSpawn
kindergarden
adults = kindergarden[0]
week[6] = week[6] + adults
kindergarden[0] = 0
kindergarden
week

/// day 2

readyToSpawn = week[0]
kindergarden = kindergarden.shiftRight()
week = week.shiftRight()
kindergarden[2] = readyToSpawn
kindergarden
adults = kindergarden[0]
week[6] = week[6] + adults
kindergarden[0] = 0
kindergarden
week

/// day 3
readyToSpawn = week[0]
kindergarden = kindergarden.shiftRight()
week = week.shiftRight()
kindergarden[2] = readyToSpawn
kindergarden
adults = kindergarden[0]
week[6] = week[6] + adults
kindergarden[0] = 0
kindergarden
week

/// day 4
readyToSpawn = week[0]
kindergarden = kindergarden.shiftRight()
week = week.shiftRight()
kindergarden[2] = readyToSpawn
kindergarden
adults = kindergarden[0]
week[6] = week[6] + adults
kindergarden[0] = 0
kindergarden
week

/// day 5
readyToSpawn = week[0]
kindergarden = kindergarden.shiftRight()
week = week.shiftRight()
kindergarden[2] = readyToSpawn
kindergarden
adults = kindergarden[0]
week[6] = week[6] + adults
kindergarden[0] = 0
kindergarden
week

/// day 6
readyToSpawn = week[0]
kindergarden = kindergarden.shiftRight()
week = week.shiftRight()
kindergarden[2] = readyToSpawn
kindergarden
adults = kindergarden[0]
week[6] = week[6] + adults
kindergarden[0] = 0
kindergarden
week
/// day 7
readyToSpawn = week[0]
kindergarden = kindergarden.shiftRight()
week = week.shiftRight()
kindergarden[2] = readyToSpawn
kindergarden
adults = kindergarden[0]
week[6] = week[6] + adults
kindergarden[0] = 0
kindergarden
week

extension Array {
    func shiftRight(_ amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }

    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}

//week = week.shiftRight()
week
struct Spawn: Sequence {
    let seed: [Int]
    
    func makeIterator() -> SpawnIterator {
        return SpawnIterator(self)
    }
}
struct SpawnIterator: IteratorProtocol {
    var times = 80
    /// reserving place
    var week: [Int]
    var kindergarden: [Int] = []
    
    var readyToSpawn: Int = 0
    var teens: Int = 0 // the fishes that graduate from kindergarden
    
    init(_ spawn: Spawn) {
        week = Array(repeating: 0, count: 7)
        kindergarden = Array(repeating: 0, count: 3)
        /// init my week array transferring the values from
        for timeLeftToSpawn in seed { week[timeLeftToSpawn] += 1 }
    }
    
    /// lets return a tuple, because at the end I need to count all fishes in both arrays
    mutating func next() -> (kindergarden: [Int], week: [Int])? {
        defer { times -= 1 }
        guard times > 0 else { return nil }
        /// here the order matters a lot!
        readyToSpawn = week[0]
        kindergarden = kindergarden.shiftRight()
        week = week.shiftRight()
        kindergarden[2] = readyToSpawn
        /// check if someone finished kindergarden
        teens = kindergarden[0]
        /// if so merge with the other fishes at day 6
        week[6] = week[6] + teens
        /// and reset because they do not want to be shifted back to kindergarden day -2
        kindergarden[0] = 0
        return (kindergarden, week)
    }
}
let glowingLanternfishesSchool = Spawn(seed: seed )
for (i, spawn) in glowingLanternfishesSchool.enumerated() {
   print("\(i) \(spawn.0) \(spawn.1)")
    if i == 79 {
        print(spawn.0.reduce(0,+) + spawn.1.reduce(0,+) )
    }
}
