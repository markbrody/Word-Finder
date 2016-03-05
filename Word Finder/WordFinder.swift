//
//  WordFinder.swift
//  Word Finder
//
//  Created by Mark Brody on 3/5/16.
//  Copyright © 2016 Mark Brody. All rights reserved.
//

import Foundation

struct WordFinder {
    var knownWords: [String:Int] = [:]
    
    mutating func train(word: String) {
        knownWords[word] = knownWords[word]?.successor() ?? 1
    }

    func known<S: SequenceType where S.Generator.Element == String>(words: S) -> Set<String>? {
        let s = Set(words.filter() { self.knownWords.indexForKey($0) != nil })
        return s.isEmpty ? nil : s
    }
    
    func correct(word: String) -> Set<String>? {
        let knowns = known([word]) ?? known(edits(word))
        return knowns ?? []
    }
    
    func edits(word: String) -> Set<String> {
        if word.isEmpty {
            return []
        }
        
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        
        let splits = word.characters.indices.map {
            (word[word.startIndex..<$0], word[$0..<word.endIndex])
        }
        
        let deletes = splits.map {
            $0 + $1.substringWithRange(1, end: $1.characters.count)
        }
        
        let transposes: [String] = splits.map { left, right in
            if let fst = right.characters.first {
                let drop1 = String(right.characters.dropFirst())
                if let snd = drop1.characters.first {
                    let drop2 = String(drop1.characters.dropFirst())
                    return "\(left)\(snd)\(fst)\(drop2)"
                }
                else {
                    return ""
                }
            }
            return ""
            }.filter { !$0.isEmpty }
        
        let replaces = splits.flatMap { left, right in
            alphabet.characters.indices.map {
                "\(left)\(alphabet[$0])" + String(right.characters.dropFirst())
            }
        }
        
        let inserts = splits.flatMap { left, right in
            alphabet.characters.indices.map {
                "\(left)\(alphabet[$0])\(right)"
            }
        }
        
        return Set(deletes + transposes + replaces + inserts)
        
    }

}
