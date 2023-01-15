//
//  MKAnnotatedFacility.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 15.01.23.
//

import Foundation
import CoreLocation

final class MKAnnotatedFacility {
    
    let id: String
    let currency: String?
    let townName: String
    let streetName: String
    let buildingNumber: String
    let addressLine: String?
    let availability: String
    let latitude: Double
    let longitude: Double
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    init(id: String,
         currency: String,
         townName: String,
         streetName: String,
         buildingNumber: String,
         addressLine: String,
         availability: String,
         latitude: Double,
         longitude: Double) {
        
        self.id = id
        self.currency = currency
        self.townName = townName
        self.streetName = streetName
        self.buildingNumber = buildingNumber
        self.addressLine = addressLine
        self.availability = availability
        self.latitude = latitude
        self.longitude = longitude
    }
        
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
