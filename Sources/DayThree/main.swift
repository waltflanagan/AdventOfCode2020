//
//  File.swift
//  
//
//  Created by Michael Simons on 12/3/20.
//

import Foundation

struct Point {
    let x: Int
    let y: Int
}

extension Point:CustomStringConvertible {
    var description: String {
        return "(\(x), \(y))"
    }
}

extension StringProtocol {
    public subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}


extension Point {
    static func + (left: Point, right: Point) -> Point {
        return Point(x: left.x + right.x, y: left.y + right.y)
    }
}

struct Map {
    let data: [String]
    let width: Int
    
    init(_ string: String) {
        let parsedData = string.components(separatedBy: "\n")
        width = parsedData.first?.count ?? 1
        data = parsedData
    }
    
    subscript(p: Point) -> Character? {
        guard p.y < data.count else { return nil }

        return data[p.y][ p.x % width ]
    }
    
    func countTreesForSlope(_ slope: Point) -> Int {
        var treeCount = 0
        var currentPoint = Point(x: 0, y: 0)
        
        while let test = map[currentPoint] {
            if test == Character("#") {
                treeCount += 1
            }
            
            currentPoint = currentPoint + slope
        }
        
        return treeCount
    }
}

let map = Map(input)
let slopes = [
    Point(x: 1, y: 1),
    Point(x: 3, y: 1),
    Point(x: 5, y: 1),
    Point(x: 7, y: 1),
    Point(x: 1, y: 2),
]

let treesHit = slopes.map({ map.countTreesForSlope($0) })

for (treesHit, slope) in zip(treesHit, slopes) {
    print("Hit \(treesHit) trees for slope \(slope)")
}

print("Answer: \(treesHit.reduce(1, *))")
