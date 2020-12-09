//
//  File.swift
//  
//
//  Created by Michael Simons on 12/9/20.
//

import Foundation


struct XmasCipher {
    let preambleSize: Int
    let input: [Int]
    
    func firstInvalid() -> Int {
        
        var currentNumber = 0
    
        for i in preambleSize..<input.count {
            let priorNumbers = Set(input[i-preambleSize..<i])
            currentNumber = input[i]
            
            var valid = false
            for n in priorNumbers {
                if priorNumbers.contains(currentNumber - n) {
                    valid = true
                    continue
                }
            }
            
            if !valid {
                return currentNumber
            }
        }
        
        return -1
    }
    
    func breakWith(_ number: Int)  -> Int {
        var first = 0
        var last = 1
        var sum = input[first] + input[last]
        
        while first < input.count - 1 {
            while sum < number {
                last += 1
                sum += input[last]
            }
            
            while sum > number {
                sum -= input[first]
                first += 1
            }
        
            if sum == number {
                let max = input[first...last].max() ?? 0
                let min = input[first...last].min() ?? 0
                return max + min
            }
        }

        return -1
    }
    
}

let cipher = XmasCipher(preambleSize: 5, input: testInput)
print("Test Input first invalid - \(cipher.firstInvalid()) - \(cipher.breakWith(127))")

let realCipher = XmasCipher(preambleSize: 25, input: realInput)
print("Real Input first invalid - \(realCipher.firstInvalid()) - \(realCipher.breakWith(88311122))")
