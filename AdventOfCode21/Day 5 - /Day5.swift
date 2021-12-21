//
//  Day 1 - Sonar Sweep.swift
//  AdventOfCode21
//
//  Created by Laurent B on 04/12/2021.
//

import Foundation

enum LineOrientation {
    case horizontal, vertical, diagonal, unknown
}

func checkIntersections(for input: [Line]) -> Int {
    /// empty start
    var intersections: Set<Point> = []
    var accumulator: Set<Point> = Set(input.first!.points)
    for line in input.dropFirst() {
        let intersection = accumulator.intersection(Set(line.points))
        intersections = intersections.union(intersection)
        accumulator = accumulator.union(Set(line.points))
    }
    return intersections.count
}

func day5() {
    let input: [Line] = getInputDay5()
    
    /// this if I wantto draw them on the iPad later
    let canvasWidth: Int = input.reduce(0) { max($0, Int($1.highestX)) }
    let canvasHeight: Int = input.reduce(0) { Int(max($0, Int($1.highestY))) }
    print("canvasWidth \(canvasWidth), canvasHeight \(canvasHeight)")
    /// the lines will have int points for the challenge!
    /// fill the lines with points . only horiz and vert ones
    let lines: [Line] = input.filter {
        $0.orientation == .horizontal || $0.orientation == .vertical
    }
    
    let solutionDay2a = checkIntersections(for: lines)
    print("Solution day2 - Part1: \(solutionDay2a)")

    let solutionDay2b = checkIntersections(for: input)
    print("Solution day2 - Part2: \(solutionDay2b)")
}

struct Point : Hashable {
    let x: Int
    let y: Int
}

struct Line {
    var points = [Point]()
    // var color = Color.blue // for swiftUI!
    var orientation: LineOrientation
    var width = 3.0
    
    init(pointA: Point, pointB: Point) {
        var allPoints: Set<Point> = []
        self.highestX = Int(max(pointA.x, pointB.x))
        self.highestY = Int(max(pointA.y, pointB.y))
        self.lowestX = Int(min(pointA.x, pointB.x))
        self.lowestY = Int(min(pointA.y, pointB.y))
        
        /// get orientation
        if pointA.y == pointB.y {
            self.orientation = .horizontal
            let y = lowestY
            for x in lowestX...highestX {
                let p = Point(x: x, y: y)
                allPoints.insert(p)
            }
            self.points = Array(allPoints)
        } else if pointA.x == pointB.x {
            self.orientation = .vertical
            let x = lowestX
            for y in lowestY...highestY {
                let p = Point(x: x, y: y)
                allPoints.insert(p)
            }
            self.points = Array(allPoints)
        } else {
            self.orientation = .diagonal
            let diff = pointB.x - pointA.x
            if pointA.x < pointB.x && pointA.y < pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x += 1; y += 1
                }
            }
            if pointA.x > pointB.x && pointA.y < pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x -= 1; y += 1
                }
            }
            if pointA.x < pointB.x && pointA.y > pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x += 1; y -= 1
                }
            }
            if pointA.x > pointB.x && pointA.y > pointB.y {
                var x = pointA.x
                var y = pointA.y
                for _ in 0...abs(diff) {
                    let p = Point(x: x, y: y)
                    allPoints.insert(p)
                    x -= 1; y -= 1
                }
            }
            self.points = Array(allPoints)
        }
    }
    var highestX: Int
    var highestY: Int
    var lowestX: Int
    var lowestY: Int
}

func getInputDay5() -> [Line] {
    var input: [Line] = []
    do {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "ResourceBundle.bundle", relativeTo: currentDirectory)
        let bundle = Bundle(url: bundleURL)
        if let inputFileURL = bundle?.url(forResource: "input-5", withExtension: "txt") {
            do {
                input = try String(contentsOf: inputFileURL)
                    .split(separator: "\n")
                    .map {
                        let row: [String] = String($0).getTrimmedCapturedGroupsFrom(regexPattern: "(\\d+),(\\d+) -> (\\d+),(\\d+)") ?? []
                        return Line(
                            pointA: Point(x: Int(row[0])!, y: Int(row[1])!),
                            pointB: Point(x: Int(row[2])!, y: Int(row[3])!))
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    return input
}

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
