//
//  Regex.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation

func extractUserHandles(from text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: #"\@\w+"#, options: [])
        let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        let userHandles = results.map { result -> String in
            let startIndex = text.index(text.startIndex, offsetBy: result.range.lowerBound)
            let endIndex = text.index(text.startIndex, offsetBy: result.range.upperBound)
            return String(text[startIndex..<endIndex])
        }
        
        return userHandles
    } catch {
        print("Error creating regular expression: \(error)")
        return []
    }
}

func extractHashtags(from text: String) -> [String] {
    do {
//            let regex = try NSRegularExpression(pattern: #"\#\w+"#, options: [])
        let regex = try NSRegularExpression(pattern: "(?i)#\\w+[\\p{L}\\p{N}_]*")
        let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        let hashtags = results.map { result -> String in
            let startIndex = text.index(text.startIndex, offsetBy: result.range.lowerBound)
            let endIndex = text.index(text.startIndex, offsetBy: result.range.upperBound)
            return String(text[startIndex..<endIndex])
        }
        
        return hashtags
    } catch {
        print("Error creating regular expression: \(error)")
        return []
    }
}

