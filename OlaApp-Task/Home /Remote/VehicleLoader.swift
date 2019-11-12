//
//  VehicleLoader.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import Foundation

struct VehicleLoader {
    
    private let networking: Networking
    
    init(networking: @escaping Networking = URLSession.shared.request) {
        self.networking = networking
    }
    
    func loadProduct() -> Future<Vehicles> {
        return networking(.fetchVehicleList()).decoded()
    }
}
