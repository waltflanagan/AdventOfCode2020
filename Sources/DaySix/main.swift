//
//  File.swift
//  
//
//  Created by Michael Simons on 12/6/20.
//

import Foundation




struct CustomsForm {
    let count: Int
    init(_ string: String) {
        let entries = string.components(separatedBy: .newlines)
        var characterSet = Set<Character>()
        
        for entry in entries {
            characterSet.formUnion(Set(entry))
        }
        
        count = characterSet.count
    }
    
    init(partTwo string: String) {
        let entries = string.components(separatedBy: .newlines)
        var characterSet = Set<Character>(entries.first!)
        
        for entry in entries {
            characterSet.formIntersection(Set(entry))
        }
        
        count = characterSet.count
    }
}


let total = input.components(separatedBy: "\n\n").map { CustomsForm($0).count }.reduce(0, +)

print("Part 1: \(total)")
let total2 = input.components(separatedBy: "\n\n").map { CustomsForm(partTwo: $0).count }.reduce(0, +)

print("Part 2: \(total2)")
