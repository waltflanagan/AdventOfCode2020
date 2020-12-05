//
//  File.swift
//  
//
//  Created by Michael Simons on 12/5/20.
//

import Foundation


struct BoardingPass {
    let id: Int
    
    init(string: String) {
        var id: Int = 0
        
        for (index, character) in string.reversed().enumerated() {
            let char = String(character)
            
            switch char {
            case "B", "R":
                id += (pow(2, index) as NSDecimalNumber).intValue
            default:
                break
            }
        }
        
        self.id = id
    }
    
    
}

let passStrings = input.components(separatedBy: .newlines)
let ids = passStrings.map({ BoardingPass(string: $0 ).id })

print("Day 1: Max pass ID \(ids.max())")

let sortedIds = ids.sorted()

for (index, id) in sortedIds.enumerated() {
    if sortedIds[index + 1] != id + 1 {
        print("should be \(id + 1)")
        break
    }
}

print("\(sortedIds)")

