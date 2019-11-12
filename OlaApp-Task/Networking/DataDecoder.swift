//
//  DataDecoder.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import Foundation

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

extension Future where Value == Data {
    func decoded<T: Decodable>() -> Future<T> {
        return transformed{ try newJSONDecoder().decode(T.self, from: $0) }
    }
}
