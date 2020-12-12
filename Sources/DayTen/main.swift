//
//  File.swift
//  
//
//  Created by Michael Simons on 12/10/20.
//

import Foundation


var sorted = [0]
sorted.append(contentsOf: input.sorted())


print(" first - \(sorted.first ?? 0)")

var ones = 0
var threes = 0

let differences: [Int] = sorted.enumerated().map { (index, adaptor) in
    guard index < sorted.count - 1 else {
        threes += 1
        return 3
    }
    let next = sorted[index + 1]
    let current = adaptor
    let difference = next - current
    
    if difference == 1 {
        ones += 1
    } else if difference == 3 {
        threes += 1
    }
    
    return sorted[index + 1] - adaptor
}

print("\(ones) \(threes) \(ones * threes)" )

struct Adaptor {
    let value: Int
    let children: [Int]
}

let inRange: [Int] = sorted.enumerated().map { (index, adaptor) in
    guard index < sorted.count - 1 else {
        return 1
    }
    
    var count = 0
    
    var endIndex: Int = index
    
    let _ = sorted.formIndex(&endIndex, offsetBy: 3, limitedBy: sorted.endIndex)
    
    let next = sorted[index..<endIndex]
    
    
    for n in next {
        if adaptor - n <= 3 {
            count += 1
        }
    }
    
    return count
}


print("\(inRange.count)")
//print("\(inRange.reduce(1, *))")
