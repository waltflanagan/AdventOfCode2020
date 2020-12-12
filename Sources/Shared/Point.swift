//
//  File.swift
//  
//
//  Created by Michael Simons on 12/12/20.
//

import Foundation

public struct Point {
    public let x: Int
    public let y: Int
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Point: CustomStringConvertible {
    public var description: String {
        return "(\(x), \(y))"
    }
}

extension Point {
    public static func + (left: Point, right: Point) -> Point {
        return Point(x: left.x + right.x, y: left.y + right.y)
    }
    
    public static func - (left: Point, right: Point) -> Point {
        return Point(x: left.x - right.x, y: left.y - right.y)
    }
    
    public static func * (left: Point, scale: Int) -> Point {
        return Point(x: left.x * scale, y: left.y * scale)
    }
}
