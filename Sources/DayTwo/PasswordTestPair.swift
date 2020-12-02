//
//  File.swift
//  
//
//  Created by Michael Simons on 12/2/20.
//

import Foundation

public struct PasswordRulePair {
    public let range: ClosedRange<Int>
    public let character: Character
    public let testPassword: String
    
    public let positionOne: Int
    public let positionTwo: Int
    
    init(string: String) {
        let components = string.components(separatedBy: " ")
        
        let rangeComponents = components[0].components(separatedBy: "-")
        
        let minimum = Int(rangeComponents.first!)!
        let maximum = Int(rangeComponents.last!)!
        positionOne = minimum - 1
        positionTwo = maximum - 1
        
        range = minimum...maximum
        character = components[1].first!
        testPassword = components[2]
    }
}
