//
//  AlterVistaURLParameters.swift
//  Misnomer
//
//  Created by James Kuang on 6/27/16.
//  Copyright © 2016 Incyc. All rights reserved.
//

import Foundation

struct AlterVistaURLParameters {
    let key = "HtWNNheK1dlql76iDPNs"
    let language = "en_US"
    let output = "json"
    let word: String

    let baseUrl = "http://thesaurus.altervista.org/thesaurus/v1"
}

extension AlterVistaURLParameters: URLGenerating {
    var url: URL {
        guard let encodedWord = word.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { fatalError("Word is not encodable") }
        guard let url = URL(string: "\(baseUrl)?key=\(key)&language=\(language)&output=\(output)&word=\(encodedWord)") else { fatalError("Can't create URL") }
        return url
    }
}
