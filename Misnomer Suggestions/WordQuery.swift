//
//  WordQuery.swift
//  Misnomer
//
//  Created by James Kuang on 6/28/16.
//  Copyright © 2016 Incyc. All rights reserved.
//

import Foundation

struct WordQuery {
    let word: String
}

extension WordQuery {
    var synonyms: Resource<Synonyms> {
        let parameters = AlterVistaURLParameters(word: word)
        return Resource<Synonyms>(url: parameters.url, parseJSON: { json in
            guard let response = json as? [String: Any] else { return nil }
            print(response)
            return Synonyms(word: self.word, dictionary: response)
        })
    }
}
