//
//  File.swift
//  
//
//  Created by Michael Simons on 12/9/20.
//

import Foundation

enum Instruction: String {
    case nop
    case acc
    case jmp
}

extension String: Error {}

let operations = input.components(separatedBy: .newlines).compactMap { Operation($0) }

struct Operation {
    let instruction: Instruction
    let value: Int
    var executed = false
    init?(_ string: String) {
        let components = string.components(separatedBy: .whitespaces)
        guard let instruction = Instruction(rawValue: components[0]), let value = Int(components[1]) else { return nil }
        self.instruction = instruction
        self.value = value
    }
    
    mutating func execute(_ process: Process) throws {
        guard !executed else {
            print("accumulator - \(process.accumulator)")
            throw "Rentrency Detected!"
        }
        
        let flip = process.skip - 1 == 0
        
        switch instruction {
        case .nop:
            if flip {
                process.currentOperation += value
            } else {
                process.currentOperation += 1
            }
            process.skip -= 1
        case .jmp:
            if flip {
                process.currentOperation += 1
            } else {
                process.currentOperation += value
            }
            process.skip -= 1
        case .acc:
            process.accumulator += value
            process.currentOperation += 1
        }
        
        executed = true
    }
}

class Process {
    var accumulator = 0
    var currentOperation = 0
    var skip: Int
    
    var operations: [Operation]
    
    init(_ operations: [Operation], skip: Int = 0) {
        self.operations = operations
        self.skip = skip
    }
    
    func run() {
        while true {
            
            if currentOperation >= operations.count {
                print("SUCCESS - \(accumulator)")
                exit(1)
            }
            
            do {
                try operations[currentOperation].execute(self)
            } catch {
                print("\(error)")
                return
            }

        }
    }
}

let process = Process(operations)
process.run()

for i in 0..<operations.count {
    let process = Process(operations, skip: i)
    process.run()
}


