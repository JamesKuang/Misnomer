//
//  Synonyms.swift
//  Misnomer
//
//  Created by James Kuang on 6/26/16.
//  Copyright © 2016 Incyc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Synonyms {
    let word: String
    let all: Set<String>
}

extension Synonyms {
    var anySynonym: String {
        return all.first!
    }
}

extension Synonyms {
    init?(word: String, dictionary: [String: Any]) {
        guard let response = dictionary["response"] else {
            return nil
        }
        
        let json = JSON(response)
        let result = json.reduce([]) { (result, subJson) -> [String] in
            guard let synonyms = subJson.1["list"]["synonyms"].string else { return result }
            return result + synonyms.components(separatedBy: "|")
        }

        self.word = word.trimmingCharacters(in: .whitespacesAndNewlines)
        self.all = Set(result)
    }
}
