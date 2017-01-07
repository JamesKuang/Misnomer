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
}

extension AlterVistaURLParameters: URLGenerating {
    var baseUrl: String {
        return "http://thesaurus.altervista.org/thesaurus/v1"
    }
    
    var url: URL {
        return URL(string: "\(baseUrl)?key=\(key)&language=\(language)&output=\(output)&word=\(word)")!
    }
}
