//
//  File.swift
//  
//
//  Created by Michael Simons on 12/6/20.
//

import Foundation
import Shared


struct Ship {
    let heading: Heading
    let location: Point
}

extension Heading {
    func byRotating(_ degrees: Int) ->  Heading {
        let steps = degrees / 90
        
        let index = Heading.allCases.firstIndex(of: self) ?? 0
        let rotatedIndex = index + steps
        let caseCount = Heading.allCases.count
    
        return Heading.allCases[((rotatedIndex % caseCount) + caseCount ) % caseCount]
    }
}

enum Heading: CaseIterable {
    case N
    case E
    case S
    case W
    
    var asPoint: Point {
        switch self {
        case .N:
            return Point(x:0, y:1)
        case .S:
            return Point(x:0, y:-1)
        case .E:
            return Point(x:1, y:0)
        case .W:
            return Point(x:-1, y:0)
        }
    }
}

protocol ShipMoving {
    func transform(_ ship: Ship) -> Ship
}

protocol WaypointMoving {
    func transform(waypoint: Point, ship: Ship) -> (Point, Ship)
}

struct Move: ShipMoving, WaypointMoving {
    let heading: Heading
    let distance: Int
    
    func transform(_ ship: Ship) -> Ship {
        let newLocation = ship.location + (heading.asPoint * distance)
        return Ship(heading: ship.heading, location: newLocation)
    }
    
    func transform(waypoint: Point, ship: Ship) -> (Point, Ship) {
        let newWaypoint = waypoint + (heading.asPoint * distance)
        
        return (newWaypoint, ship)
    }
}

struct Forward: ShipMoving, WaypointMoving {
    let value: Int

    func transform(_ ship: Ship) -> Ship {
        let newLocation = ship.location + (ship.heading.asPoint * value)
        return Ship(heading: ship.heading, location: newLocation)
    }
    
    func transform(waypoint: Point, ship: Ship) -> (Point, Ship) {
//        let diff = waypoint - ship.location
//        print("diff - \(diff)")
        let newLocation = ship.location + (waypoint * value)
        
        return (waypoint, Ship(heading: ship.heading, location: newLocation))
    }
}

struct Turn: ShipMoving, WaypointMoving {
    let direction: Int
    let degree: Int
    
    func transform(_ ship: Ship) -> Ship {
        let newHeading = ship.heading.byRotating( direction * degree )
        return Ship(heading: newHeading, location: ship.location)
    }
    
    func transform(waypoint: Point, ship: Ship) -> (Point, Ship) {
//        let newPoint = ship.location.cgPoint.applying(affine)
        let steps = degree / 90
        
        let newPoint: Point
        switch steps % 4 {
        case 1:
            newPoint = Point(x: direction * waypoint.y, y: -direction * waypoint.x)
        case 2:
            newPoint = Point(x: -1 * waypoint.x, y: -1 * waypoint.y)
        case 3:
            newPoint = Point(x: -direction * waypoint.y, y: direction * waypoint.x)
        default:
            newPoint = waypoint
        }
        
        return (newPoint, ship)
    }
}


func movementForPartOne(_ line: [String]) -> ShipMoving {
    let instruction = line[0]
    let value = Int(line[1])!
    switch instruction {
    case "N":
        return Move(heading: .N, distance: value)
    case "S":
        return Move(heading: .S, distance: value)
    case "E":
        return Move(heading: .E, distance: value)
    case "W":
        return Move(heading: .W, distance: value)
    case "L":
        return Turn(direction: -1, degree: value)
    case "R":
        return Turn(direction: 1, degree: value)
    case "F":
        return Forward(value: value)
    default:
        return Forward(value: 0)
    }
}

func movementForPartTwo(_ line: [String]) -> WaypointMoving {
    let instruction = line[0]
    let value = Int(line[1])!
    switch instruction {
    case "N":
        return Move(heading: .N, distance: value)
    case "S":
        return Move(heading: .S, distance: value)
    case "E":
        return Move(heading: .E, distance: value)
    case "W":
        return Move(heading: .W, distance: value)
    case "L":
        return Turn(direction: -1, degree: value)
    case "R":
        return Turn(direction: 1, degree: value)
    case "F":
        return Forward(value: value)
    default:
        return Forward(value: 0)
    }
}

let stepRegex = try! RegEx(pattern: "(\\w)(\\d+)")
let stepStrings = stepRegex.matchGroups(in: input)
let movements = stepStrings.map { movementForPartOne($0) }

var ship = Ship(heading: .E, location: .identity)

for movement in movements {
    ship = movement.transform(ship)
//    print("\(ship.location)")
}

print("Ship at: \(ship.location)  - distance \(ship.location.manhattanValue)")

var shipTwo = Ship(heading: .E, location: .identity)
var waypoint = Point(x: 10, y: 1)
let partTwoMovements = stepStrings.map { movementForPartTwo($0) }

for step in stepStrings {
    let movement = movementForPartTwo(step)
    (waypoint, shipTwo) = movement.transform(waypoint: waypoint, ship: shipTwo)
    print("\(step.joined()) - \(shipTwo.location) - \(waypoint)")
}

print("Ship at: \(shipTwo.location)  - distance \(shipTwo.location.manhattanValue)")

