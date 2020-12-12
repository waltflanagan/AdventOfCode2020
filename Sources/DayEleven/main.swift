//
//  File.swift
//  
//
//  Created by Michael Simons on 12/6/20.
//

import Foundation
import Shared



extension Point {
    var neighbors: [Point] {
        
        var neighbors = [Point]()
        
        for i in -1...1 {
            for j in -1...1 {
                guard i != 0 || j != 0 else { continue }
                neighbors.append(Point(x: x + i, y: y+j))
            }
        }
        
        return neighbors
    }
    
    func occupiedNeighbors(in storage: [Point: Character])->  [Point] {
        let inputSize = Int(Double(storage.count).squareRoot())
        var neighbors = [Point]()
//        print("dealing with \(self)")
        for i in -1...1 {
            for j in -1...1 {
//                guard i != 0 || j != 0 else { continue }
                
                let direction = Point(x: i, y:j)
                for k in 0..<inputSize {
                    let testNeighbor =  self + (direction * k)
                    guard testNeighbor != self else { continue }
                    guard let test = storage[testNeighbor] else { break }

                    if test == occupied {
                        neighbors.append(testNeighbor)
                        break
                    } else if test == empty {
                        break
                    }
                    
                }
            }
        }
        
//        print("\(neighbors.count)")
        return neighbors
    }
}

let floor = Character(".")
let occupied = Character("#")
let empty = Character("L")

struct FerrySeating: Equatable, CustomStringConvertible {
    let storage: [Point: Character]
    let size: Int
    
    init( _ string: String) {
        var storage = [Point: Character]()
        let lines = string.components(separatedBy: .newlines)

        size = lines.count
        
        for (x, line) in lines.enumerated() {
            for (y, character) in line.enumerated() {
                storage[Point(x: x, y: y)] = character
            }
        }
        
        self.storage = storage
    }

    init(_ storage: [Point: Character]) {
        self.size = 10
        self.storage = storage
    }
    
    
    func next(partTwo: Bool = false) -> FerrySeating {
        let queue = DispatchQueue(label: "testing", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem)


        let newStorage = Atomic([Point: Character]())
        
        let chunks = Dictionary(grouping: storage, by: { $0.key.x })
        let group = DispatchGroup()

        for (_, chunk) in chunks {
            group.enter()
            queue.async {
                defer { group.leave() }
                for (key, current)  in chunk {
                    guard current != floor else {
                        newStorage.mutate { $0[key] = floor }
                        
                        continue
                    }
                    
                    let neighbors: [Character]
                    if partTwo {
                        neighbors = key.occupiedNeighbors(in: storage).compactMap({ storage[$0] })
                    } else {
                        neighbors = key.neighbors.compactMap({ storage[$0] })
                    }
                    
                    if current == empty, neighbors.filter({ $0 == occupied}).isEmpty {
                        newStorage.mutate { $0[key] = occupied }
                    } else if current == occupied, neighbors.filter({ $0 == occupied}).count >= 5 {
                        newStorage.mutate { $0[key] = empty }
                    } else {
                        newStorage.mutate { $0[key] = current }
                    }
                }
            }
        }
  
        group.wait()
        
        
        let next = FerrySeating(newStorage.value)
//        print("------------ next: \(next) \n-------------")
        return next
    }
    
    var description: String {
        var output = ""
        for i in 0..<size{
            var line = ""
            for j in 0..<size {
                guard let char = storage[Point(x: i, y: j)] else { break }
                line.append(char)
            }
            output += "\n\(line)"
        }
        
       return output
    }
    
}

//
//var current = FerrySeating(input)
//var count = 0
//var next = current.next()
//
//while current != next {
//    current = next
//    next = next.next()
//    count += 1
//}
//
//let solution = current.storage.filter({ $0.value == occupied }).count
//
//print("\(solution)")


// PART 2
var current = FerrySeating(input)
var count = 0
var next = current.next(partTwo: true)

while current != next {
    current = next
    next = next.next(partTwo: true)
    count += 1
//    if count > 30 {
//        print("oops")
//        break
//    }
}

let solution = current.storage.filter({ $0.value == occupied }).count

print("\(solution) after \(count)")
