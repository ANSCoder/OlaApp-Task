//
//  VehicleDetails.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 12/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import Foundation

// MARK: - Vehicle
struct Vehicle: Codable {
    let id, modelIdentifier, modelName, group: String
    let licensePlate, innerCleanliness: String
    let carImageURL: String
    let vehicleDetails: VehicleDetails
    let location: Location

    enum CodingKeys: String, CodingKey {
        case id, modelIdentifier, modelName, group, licensePlate, innerCleanliness
        case carImageURL = "carImageUrl"
        case vehicleDetails, location
    }
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double
}

// MARK: - VehicleDetails
struct VehicleDetails: Codable {
    let name, make, color, series: String
    let fuelType: String
    let fuelLevel: Double
    let transmission: String

    enum CodingKeys: String, CodingKey {
        case name, make, color, series
        case fuelType = "fuel_type"
        case fuelLevel = "fuel_level"
        case transmission
    }
}

typealias Vehicles = [Vehicle]
