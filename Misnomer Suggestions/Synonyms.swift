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
        var result = [String]()
        for (_, subJson):(String, JSON) in json {
            guard let synonyms = subJson["list"]["synonyms"].string else { continue }
            result.append(contentsOf: synonyms.components(separatedBy: "|"))
        }

        self.word = word
        self.all = Set(result)
    }
}
