//
//  File.swift
//  
//
//  Created by Michael Simons on 12/2/20.
//

import Foundation

struct Day1 {
    
    func solve() {
        let input = realInput
        
        for l in input {
            for r in input {
                if l + r == 2020 {
                    print("\(l*r)")
                }
            }
        }
        
        let set = Set(input)
        
        for l in input {
            for r in input {
                let sum = l + r
                let difference = 2020 - sum
                
                if set.contains(difference) {
                    print("\(l*r*difference)")
                }
            }
        }
    }
}
