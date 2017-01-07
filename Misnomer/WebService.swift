//
//  WebService.swift
//  Misnomer
//
//  Created by James Kuang on 6/26/16.
//  Copyright © 2016 Incyc. All rights reserved.
//

import Foundation

protocol URLParameters {
    var baseUrl: String { get }
}

protocol URLGenerating: URLParameters {
    var url: URL { get }
}

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

final class WebService {
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            let result = data.flatMap(resource.parse)
            completion(result)
        }.resume()
    }
}
