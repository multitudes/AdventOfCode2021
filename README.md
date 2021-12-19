
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
| ✅ [Day 3: Binary Diagnostic](https://adventofcode.com/2021/day/3)|⭐️||
| ✅ [Day 4: Giant Squid](https://adventofcode.com/2021/day/4)|||
| ✅ [Day 5: Hydrothermal Venture](https://adventofcode.com/2021/day/5)|||

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
Also the code is quite unreadable for once. Being used to read swift code which is expressive the below feels like coming from somewhere else... But it is fun

``` swift

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
            /// again bitwise operations here. I am still using my stride as comparing the bit positions,
            /// so if i = 5, this means 10000, and 2 << (5 - 2) is 10000
            print("oxygenGeneratorRatingArray ones are more - bit nr \(bitNumber) \(onesArray)")
            return onesArray
        } else {
            print("oxygenGeneratorRatingArray zeroes are more - bit nr \(bitNumber) \(onesArray)")
            return zeroesArray
        }
    case .co2:
        /// at the end of my loop on the inputs I check if the ones were more than the  zeroes
        if zeroesArray.count <= onesArray.count   {
            /// again bitwise operations here. I am still using my stride as comparing the bit positions,
            /// so if i = 5, this means 10000, and 2 << (5 - 2) is 10000
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
