//
//  LocationModel.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 13/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import Foundation
import MapKit

class LocationModel: NSObject, MKAnnotation {
    let title: String?
    let id: String?
    let carImageUrl: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String? = nil,
         id: String?,
         carImageUrl: String?,
         coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.id = id
        self.carImageUrl = carImageUrl
        self.coordinate = coordinate
    }
}
