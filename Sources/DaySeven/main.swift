//
//  File.swift
//  
//
//  Created by Michael Simons on 12/9/20.
//

import Foundation
import Shared


let ruleRegex = try! RegEx(pattern: "(\\w+ \\w+) bags contain (.*)")
let bagsRegex = try! RegEx(pattern: "(\\d) (\\w+ \\w+) bags?+")


let parsedInput = ruleRegex.matchGroups(in: input)
//let breakdown = bagsRegex.matchGroups(in: )

print("\(parsedInput) -  \n\(bagsRegex.matchGroups(in: parsedInput[0][1]))")



let bagRules = parsedInput.map({ BagRule($0) })
let ruleDictionary = Dictionary(grouping: bagRules, by: { $0.identifier })


struct BagRule {
    let identifier: String
    let children: [String: Int]
    init(_ rule: [String]) {
        identifier = rule[0]
        let childBags = bagsRegex.matchGroups(in: rule[1])
        var children = [String: Int]()

        for bag in childBags {
            children[bag[1]] = Int(bag[0])!
        }
        
        self.children = children
        
    }
    
    func containedBags() -> Int {
        
        let bags = children.map({ (identifier, count) in
            return count * ruleDictionary[identifier]!.first!.containedBags()
        })
        
        let count = bags.reduce(0, +)
        print("\(identifier) contains \(count) bags - children \(children.count)")
        return count + 1
    }
    
    static var empty = BagRule(["",""])
}

func find(_ bag: String = "shiny gold", rule: BagRule) -> Bool {
    
    if rule.children.keys.contains(bag) {
        return true
    }
    
    var found = false
    
    for (identifier, _) in rule.children {
        found = found || find(bag, rule: ruleDictionary[identifier, default: [BagRule(["",""])]].first!)
    }
    
    return found
}


let count = ruleDictionary.map { find(rule: $0.value.first!) }.filter({ $0}).count

print("has shiny bag - \(count)")

print("shiny bag  contains - \( ruleDictionary["shiny gold"]!.first!.containedBags() - 1 )")

