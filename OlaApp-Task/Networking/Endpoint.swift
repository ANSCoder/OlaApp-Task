//
//  Endpoint.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String
    
    enum Errors: Error {
        case invalidURL
    }
}


extension Endpoint {

    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "www.mocky.io"
        components.path = path
        return components.url
    }
}

extension Endpoint{
    static func fetchVehicleList() -> Endpoint{
        return Endpoint(
            path: "/v2/5dc3f2c13000003c003477a0"
        )
    }
}
