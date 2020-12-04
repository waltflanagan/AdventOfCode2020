//
//  File.swift
//  
//
//  Created by Michael Simons on 12/4/20.
//

import Foundation


public struct RegEx {
    private let regex: NSRegularExpression
    public typealias Options = NSRegularExpression.Options
    
    /// Creates a new Regex using `pattern`.
    ///
    /// - Parameters:
    ///     - pattern: A valid Regular Expression pattern
    ///     - options: NSRegularExpression.Options on how the RegEx should be processed.
    /// - Note: Deliminators must be double escaped. Once for Swift and once for RegEx.
    ///   Example, to math a negative integer: `RegEx(pattern: "-\d")` -> `RegEx(pattern: "-\\d")`
    /// - SeeAlso: NSRegularExpression
    /// - Throws: An Error if `pattern` is an invalid Regular Expression.
    public init(pattern: String, options: Options = []) throws {
        self.regex = try NSRegularExpression(pattern: pattern, options: options)
    }
    
    /// Returns match groups for every match of the Regex.
    ///
    /// For every match in the string, it constructs the collection
    /// of groups matched.
    ///
    ///     RegEx(pattern: "([a-z]+)([0-9]+)").matchGroups(in: "foo1 bar2 baz3")
    ///
    /// Returns `[["foo", "1"], ["bar", "2"], ["baz", "3"]]`.
    ///
    /// - Parameters:
    ///     - in: A string to check for matches to the whole Regex.
    /// - Returns: A collection where each elements is the collection of matched groups.
    public func matchGroups(in string: String) -> [[String]] {
        let nsString = NSString(string: string)
        
        return regex.matches(in: string, options: [], range: NSMakeRange(0, nsString.length)).map{ match -> [String] in
            return (1 ..< match.numberOfRanges).map { idx -> String in
                let range = match.range(at: idx)
                return range.location == NSNotFound ? "" : nsString.substring(with: range)
            }
        }
    }
}

func validYear(string: String, between first: Int, and last: Int) -> Bool {
    guard let year = Int(string), year >= first, year <= last else {
        print("invalid year \(string) not between \(first) and \(last)")
        return false
    }
    return true
}

func validColor(string: String) -> Bool {
    let regex = try! RegEx(pattern: "^#[a-fA-F0-9]{6}$")

    return regex.matchGroups(in: string).count == 1
}


func validPid(string: String) -> Bool {
    let regex = try! RegEx(pattern: "(\\d{9})")
    
    guard let groups = regex.matchGroups(in: string).first,  groups.count == 1 else { return false }
    
    return string.count == 9
}


func validSize(string: String) -> Bool {
    let regex = try! RegEx(pattern: "(\\d+)(in|cm)")
    
    guard let groups = regex.matchGroups(in: string).first, groups.count == 2 else { return false }

    let height = Int(groups.first!) ?? 0

    switch groups.last! {
    case "cm":
        return height >= 150 && height <= 193
    case "in":
        return height >= 59 && height <= 76
    default:
        return false
    }
}

enum PassportField: String, CaseIterable {
    case byr
    case iyr
    case eyr
    case hgt
    case hcl
    case ecl
    case pid
    case cid
    
    static func requiredFieldsStrings() -> Set<String> {
        let fields = Set(PassportField.allCases)
        let required = fields.subtracting(Set([.cid]))
        return Set(required.map({ $0.rawValue }))
    }
    
    
    static func requiredFields() -> Set<PassportField> {
        let fields = Set(PassportField.allCases)
        let required = fields.subtracting(Set([.cid]))
        return required
    }
    
    init?(_ data: [String]) {
        switch data.first! {
        case "byr":
            guard validYear(string: data.last!, between: 1920, and: 2002) else {
                return nil
            }
            self = .byr
        case "iyr":
            guard validYear(string: data.last!, between: 2010, and: 2020) else {
                return nil
            }
            self = .iyr
        case "eyr":
            guard  validYear(string: data.last!, between: 2020, and: 2030)  else {
                return nil
            }
            self = .eyr
        case "hgt":
            guard validSize(string: data.last!) else { return nil }
            self = .hgt
        case "hcl":
            guard validColor(string: data.last!) else { return nil }
            self = .hcl
        case "ecl":
            guard ["amb","blu","brn","gry","grn","hzl","oth"].contains(data.last!) else { return nil }
            self = .ecl
        case "pid":
            guard validPid(string: data.last!) else { return nil }
            self = .pid
        case "cid":
            self = .cid
        default:
            return nil
        }
    }
}


struct Passport {
    let foo = ""
    init?(partOneString string: String) {

        let components = string.components(separatedBy: .whitespacesAndNewlines)
            .map { $0.components(separatedBy: ":") }
        
        let fields = Dictionary(grouping: components) { $0.first! }
            
        let existingEntries = Set(Array(fields.keys))
    
        let difference = PassportField.requiredFieldsStrings().subtracting(existingEntries)
        
        guard difference.isEmpty else {
            print("Invalid: ")
            print("Missing \(difference)")
            return nil
        }
    }
    
    init?(partTwoString string: String) {

        let components = string.components(separatedBy: .whitespacesAndNewlines)
            .map { $0.components(separatedBy: ":") }
        
        let existingFields = Set(components.compactMap({ PassportField($0) } ))
        
        let difference = PassportField.requiredFields().subtracting(existingFields)
        
        guard difference.isEmpty else {
            print("Invalid: ")
            print("Missing \(difference)")
            return nil
        }
    }
}

let passportStrings = input.components(separatedBy: "\n\n")

print(passportStrings.count)

let passports = passportStrings.compactMap({ Passport(partOneString: $0) })

print("\(passports.count) valid passports")

let strictPassports = passportStrings.compactMap({ Passport(partTwoString: $0) })

print("\(strictPassports.count) valid strict passports")



