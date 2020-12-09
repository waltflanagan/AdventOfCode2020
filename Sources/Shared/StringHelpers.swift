//
//  File.swift
//  
//
//  Created by Michael Simons on 12/3/20.
//

import Foundation

extension StringProtocol {
    public subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
