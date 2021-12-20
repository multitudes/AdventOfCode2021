
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg?style=plastic)](https://opensource.org/licenses/MIT)
[![Swift](https://img.shields.io/badge/Swift-5.5.1-red.svg?style=plastic&logo=Swift&logoColor=white)](https://opensource.org/licenses/MIT)
[![twitter](https://img.shields.io/badge/twitter-wrmultitudes-blue.svg?style=plastic&logo=twitter&logoColor=white)](https://twitter.com/wrmultitudes)
[![hashnode](https://img.shields.io/badge/hashnode-laurentbrusa-blue?style=plastic&logo=hashnode&logoColor=white)](https://laurentbrusa.hashnode.dev)

# Advent Of Code 2021 in Swift ✨🏝  
 
## What is Advent of Code?
[Advent of Code](http://adventofcode.com) is an online event created by [Eric Wastl](https://twitter.com/ericwastl). Each year an advent calendar of small programming puzzles is unlocked once a day, they can be solved in any programming language you like. 

## Progress
| Day  | Part One | Part Two |
|---|:---:|:---:|
| ✅ [Day 1: Sonar Sweep](https://adventofcode.com/2021/day/1)|⭐️|⭐️|
| ✅ [Day 2: Dive!](https://adventofcode.com/2021/day/2)|⭐️|⭐️|
| ✅ [Day 3: Binary Diagnostic](https://adventofcode.com/2021/day/3)|⭐️|⭐️|
| ✅ [Day 4: Giant Squid](https://adventofcode.com/2021/day/4)|⭐️|⭐️|
| ✅ [Day 5: Hydrothermal Venture](https://adventofcode.com/2021/day/5)|⭐️|⭐️|
| ✅ [Day 6: Lanternfish](https://adventofcode.com/2021/day/6)|||
| ✅ [Day 7: The Treachery of Whales](https://adventofcode.com/2021/day/7)|||
| ✅ [Day 8: Seven Segment Search](https://adventofcode.com/2021/day/8)|||
| ✅ [Day 9: Smoke Basin](https://adventofcode.com/2021/day/9)|||
| ✅ [Day 10: Syntax Scoring](https://adventofcode.com/2021/day/10)|||
| ✅ [Day 11: Dumbo Octopus](https://adventofcode.com/2021/day/11)|||

## Preparing the environment

[In 2019](https://github.com/multitudes/Advent-of-Code-2019/blob/master/README.md) I did the challenges in the Xcode Swift playgrounds.  
Last year I did use the playgrounds but also I wanted to try something different with the [Swift package manager](https://swift.org/getting-started/#using-the-package-manager).
You can read more in my blog post [here](https://laurentbrusa.hashnode.dev/preparing-xcode-for-the-advent-of-code-2020-in-swift).  

This year I am exploring the Xcode command line app.



## Advent of Code 2021 Story

You're minding your own business on a ship at sea when the overboard alarm goes off! You rush to see if you can help. Apparently, one of the Elves tripped and accidentally sent the sleigh keys flying into the ocean!

Before you know it, you're inside a submarine the Elves keep ready for situations like this. It's covered in Christmas lights (because of course it is), and it even has an experimental antenna that should be able to track the keys if you can boost its signal strength high enough; there's a little meter that indicates the antenna's signal strength by displaying 0-50 stars.

Your instincts tell you that in order to save Christmas, you'll need to get all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star.

# A sort of diary

## Day 1 
This year I wanted to create a different work environment and try to use the command line app template in Xcode. Something I never use.
First obstacle: where is my input file?  
Mostly every challenge comes with an input file.  
Little did I know that this command line app template doesn’t come with a Bundle!  
If you are interested in thisthen please visit [my blog](https://laurentbrusa.hashnode.dev/setting-up-this-year-advent-of-code-2021-in-swift) to see how I solved this...  

Now back to the challenges...  
Part 1 could be solved this way, using `adjacentPairs` from the swift algorithm package, with a loop:

```swift
 var solutionDay1a = 0
 for pair in input.adjacentPairs() {
     if pair.0 < pair.1 {
         solutionDay1a += 1
     }
 }
```

Writing short code it is frowned upon and can sometimes be more difficult to read but it’s not always bad.  
In this case using functional programming: 
- it actually has a better performance because being optimised for fast execution, so operations on large arrays are performed lazily, it means that data is written when needed skipping intermediate steps.
- Functional programming can be better readable than longer chunk of code. For instance, when I see a map operator, I know that each element of an array is being transformed with the code in the body of the map without side effects. And the results are being passed to the next operator etc.  

Here I split my input array into adjacent pairs and each one is being reduced into one total sum. In each pair, I check wether the first variable is smaller than the second and if so I increment the total sum.

```swift
let solutionDay1a = input
    .adjacentPairs()
    .reduce(into: 0) {  total , pair  in
        total = (pair.0 < pair.1) ? total + 1 : total
    }
```

This can be written more tersely like this, but maybe is not very clear anymore what it is happening 🙈

```swift
 let solutionDay1a = input.adjacentPairs().reduce(0) { 
    ($1.0 < $1.1) ? $0 + 1 : $0 
}
```

Part 2 is just like part 1, only that I look over a window of three measurements to check if the next window is bigger, then I increment my total. This again was not difficult using the algorithm package. There is `windows`function made specifically for this case. :)  

```swift
let solutionDay1b = input
        .windows(ofCount: 3)
        .map {$0.reduce(0,+)}
        .adjacentPairs()
        .reduce(into: 0) { partialResult, windowSums in
            partialResult = (windowSums.0 < windowSums.1) ? partialResult + 1 : partialResult
        }
```


## Day 2 

I decided to use tuples which are a great very descriptive and expressive swift feature together with an enum to move the submarine up down and forward. For part two I added some more functions to my model and one extra variable.
My model is a struct. I do not change the struct which is immutable but instead I return a new instance for every change...

```swift
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

let solutionDay2b = input.reduce(Position()) { position, course in
    switch course.command {
    case .forward:
        return position.increaseForwardWithAim(units: course.amount)
    case .down:
        return position.increaseAim(aim: course.amount)
    case .up:
        return position.decreaseAim(aim: course.amount)
    }
}.currentPositionResult

print("Solution day2 - Part2: \(solutionDay2b)")
```


## Day 3

I have binary numbers in input so I thought why not use bitwise operators instead of just using strings. The interesting thing is that the gammaRate and the epsilonRate in part 1 have inversed bit, and I could have also used the `NOT` or `~` bitwise operator. The only problem is that I have 12 bits in my puzzle input and it would work better if I had a UInt12. ex 1011010111011 is inverted 0100101000100. but the same input in Uint32 written down is 00001011010111011 and inverted is 11110100101000100! basically not what I need for the puzzle.  
More info about these operators are in the docs: [https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html).  
Also the code is quite unreadable sometimes. Being used to read swift code which is expressive the below feels like coming from somewhere else... But it is fun!  
Bit difficult to comment this code. Better check on the website the original challenge if something is not clear :)

``` swift
/// I created this function which is reusable for part two... and uses bitwise operators to look which bits are ones or zeroes for a specific bitNumber and return the two arrays of ones and zeroes
func loopOn(array input: [String], bitNumber: Int) -> (ones: [String], zeroes: [String]) {
    /// initialise my counts
    var onesArray: [String] = []; var zeroesArray: [String] = []
    /// looping on the inputs
    for binary in input {
        /// my binary input transformed from string to Int
        let binaryInt = UInt(binary, radix: 2)!
        
        /// I do a logic AND between my binary and the current bit like
        /// ex binary is 11011 and my i is 5 I will compare the two:
        /// 11011 & 10000 which will give 10000 = 16
        /// I look only for zeroes first ... because practical
        if (binaryInt & (2 << (bitNumber - 2))) == 0 {
            zeroesArray.append(binary)
        } else {
            onesArray.append(binary)
        }
    }
    return (onesArray, zeroesArray)
}

/// bitwise operation - If I have 5 bits I will start from 5, then 4 ... till one
for bitNumber in stride(from: numberOfBits, to: 0, by: -1) {
    /// `loopOn()` returns two arrays of strings, the one that passed the test to have a one at the bitnumber position and the ones with the zeroes for each bit number position passed down in the for loop
    let (ones, zeroes) = loopOn(array: input, bitNumber: bitNumber)
    /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
    if ones.count > zeroes.count {
        /// again bitwise operations here. I am still using my stride as comparing the bit positions,
        /// so if i = 5, this means 10000, and 2 << (5 - 2) is 10000
        gammaRate += (2 << (bitNumber - 2))
    } else {
        epsilonRate += (2 << (bitNumber - 2))
    }
}
powerConsumption = gammaRate * epsilonRate
let solutionDay2a = powerConsumption
```
For part 2 I need to iterate on the arrays sequentially again, only that the arrays are being filtered, so I will keep on iterating until I have only one value left. I thought of using the `zip` swift operator but that one would not do because the arrays do not have the same length. I could use padding but this is extra work and is not making the code better.

```swift
/// this will be my solution
var lifeSupportRating = 0

/// optional because converting a string to int will be always an optional anyway
var oxygenGeneratorRating: Int? = nil
var co2ScrubberRating: Int? = nil

/// initialize my arrays to loop on - at the beginning they will have both the same input
var oxygenGeneratorRatingArray: [String] = input
var co2ScrubberRatingArray: [String] = input

/// This just for clarity. I have two cases for the rating and I will calculate them separately in the same function below
enum Rating {
    case oxygen, co2
}

/// convenience function. I will update the array in inpit depending if I am looking for oxigen rating or co2 rating.
func updateRatingsArray(inputArray input: [String], for rating: Rating, bitNumber: Int) -> [String] {
    let (onesArray, zeroesArray) = loopOn(array: input, bitNumber: bitNumber)

    switch rating {
    case .oxygen:
        /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
        if onesArray.count >= zeroesArray.count {
            print("oxygenGeneratorRatingArray ones are more - bit nr \(bitNumber) \(onesArray)")
            return onesArray
        } else {
            print("oxygenGeneratorRatingArray zeroes are more - bit nr \(bitNumber) \(onesArray)")
            return zeroesArray
        }
    case .co2:
        /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
        if zeroesArray.count <= onesArray.count   {
            print("co2ScrubberRatingArray zeroes are more - bit nr \(bitNumber) \(zeroesArray)")
            return zeroesArray
        } else {
            print("co2ScrubberRatingArray zeroes are less - bit nr \(bitNumber) \(onesArray)")
            return onesArray
        }
    }
}
/// again using the stride looping on the bits
for bitNumber in stride(from: numberOfBits, to: 0, by: -1) {
    /// I only update my array if it is not empty - I might have the solution already for the other array but not for all
    if !oxygenGeneratorRatingArray.isEmpty {
        oxygenGeneratorRatingArray = updateRatingsArray(inputArray: oxygenGeneratorRatingArray, for: .oxygen, bitNumber: bitNumber)}
    /// Here i have a solution and I update my property with a value
    if oxygenGeneratorRatingArray.count == 1 {
        oxygenGeneratorRating = Int(oxygenGeneratorRatingArray[0], radix: 2 )
    }
    /// I only update my array if it is not empty
    if !co2ScrubberRatingArray.isEmpty {
        co2ScrubberRatingArray = updateRatingsArray(inputArray: co2ScrubberRatingArray, for: .co2, bitNumber: bitNumber)}
    /// Here i have a solution and I update my property with a value
    if co2ScrubberRatingArray.count == 1 {
        co2ScrubberRating = Int(co2ScrubberRatingArray[0], radix: 2)
    }
    /// if they are both non nil... then I can break
    if let oxygenGeneratorRating = oxygenGeneratorRating,
        let co2ScrubberRating = co2ScrubberRating {
        lifeSupportRating = oxygenGeneratorRating * co2ScrubberRating
        break
    }
}

let solutionDay2b = lifeSupportRating

```

## Day 4
Playing Bingo with the squid. Getting the correct input was trickier than I thought. Maybe I underestimaterd it and lost time debugging it when it did not work as espected.  
This is to get the input. I return a tuple, The bingo numbers and the boards:  

```swift
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
```
The board is the class that once initialized gets the logic to check if the bingo number gonna win or not.  
I stored the row but I found a way to store the column as well, so I can check with the sets if the row or columns are fully marked. Found this quite nice extension on SO by Martin K to get the columns of a nested array and I used it to simplify my code.
```swift
extension Array where Element : Collection {
    subscript(column column : Element.Index) -> [ Element.Iterator.Element ] {
        return map { $0[ column ] }
    }
}
```
So the final function for the solutions rwill rely on the instance of the boards to do the math. The code is a bit longer but the main func is:
```swift
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
```

## Day 5

I first used a regex to get my inpits mapped. Used a custom struct `Point` instead of the `CGPoint` because I need to make it conform to `Hashable` to use in `Set` instances.  
Using the input file to initialise an array of `Lines`.  

```swift
/// my regex convenience function
extension String {
    func getTrimmedCapturedGroupsFrom(regexPattern: String)-> [String]? {
        let text = self
        let regex = try? NSRegularExpression(pattern: regexPattern)
        
        let match = regex?.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
        
        if let match = match {
            return (0..<match.numberOfRanges).compactMap {
                if let range = Range(match.range(at: $0), in: text) {
                    return $0 > 0 ? String(text[range]).trimmingCharacters(in: .whitespaces) : nil
                }
                return nil
            }
        }
        return nil
    }
}

```
And once I have an array of `Line` as input I use this to get the intersections:
```swift
func checkIntersections(for input: [Line]) -> Int {
    var intersections: Set<Point> = []
    var accumulator: Set<Point> = Set(input.first!.points)
    for line in input.dropFirst() {
        let intersection = accumulator.intersection(Set(line.points))
        intersections = intersections.union(intersection)
        accumulator = accumulator.union(Set(line.points))
    }
    return intersections.count
}
```
Of course the full code is in the repo but the solution will be :
```swift
let input: [Line] = getInputDay5()

/// for the first part I check only for horiz and vert lines
let lines: [Line] = input.filter {
    $0.orientation == .horizontal || $0.orientation == .vertical
}
let solutionDay2a = checkIntersections(for: lines)
print("Solution day2 - Part1: \(solutionDay2a)")
/// part two checks all of them but the intermediate points in the lines are already calculated in the init of the `Line` struct so it was easy... 
let solutionDay2b = checkIntersections(for: input)

print("Solution day2 - Part2: \(solutionDay2b)")
```
I made a small app in SwiftUI to visualize the lines using the canvas view:  

<p align="center">
  <img src="https://cdn.hashnode.com/res/hashnode/image/upload/v1640006190480/tCnhA0rbu.jpeg" width="200"  title="example view">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.hashnode.com/res/hashnode/image/upload/v1640006196121/3bLORvK_N.png" width="200"  title="solution view">
</p>
<br></br>
