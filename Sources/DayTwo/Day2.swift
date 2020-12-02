//
//  File.swift
//  
//
//  Created by Michael Simons on 12/2/20.
//

import Foundation


struct Day2 {
    func solve() {
        let input = realInput

        let partOneValid = input.filter({ $0.isValid })

        print("Part 1: \(partOneValid.count)")
        
        let partTwoValid = input.filter({ $0.isValidP2 })

        print("Part 2: \(partTwoValid.count)")
    }
}

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}

extension PasswordRulePair {
    var isValid: Bool {
    
        let characterCount = testPassword.filter({ $0 == character}).count
        
        return range.contains(characterCount)
    }
    
    var isValidP2: Bool {
        return (testPassword[testPassword.index(testPassword.startIndex, offsetBy: positionOne)] == character) ^ (testPassword[testPassword.index(testPassword.startIndex, offsetBy: positionTwo)] == character)
    }

}
