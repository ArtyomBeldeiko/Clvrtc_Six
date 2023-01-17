//
//  MKAnnotatedBranchBank.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 12.01.23.
//

import Foundation
import MapKit

final class MKAnnotatedBranchBank: NSObject, MKAnnotation {
    let branchID: String
    let name: String
    let cbu: String
    let equeue: Int
    let wifi: Int
    let streetName: String
    let buildingNumber: String
    let department: String
    let townName: String
    let addressLine: String
    let addressDescription: String
    let latitude: String
    let longitude: String
    let standardAvailability: String
    let currency: String
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    init(branchID: String,
         name: String,
         cbu: String,
         equeue: Int,
         wifi: Int,
         streetName: String,
         buildingNumber: String,
         department: String,
         townName: String,
         addressLine: String,
         addressDescription: String,
         latitude: String,
         longitude: String,
         standardAvailability: String,
         currency: String) {
        
        self.branchID = branchID
        self.name = name
        self.cbu = cbu
        self.equeue = equeue
        self.wifi = wifi
        self.streetName = streetName
        self.buildingNumber = buildingNumber
        self.department = department
        self.townName = townName
        self.addressLine = addressLine
        self.addressDescription = addressDescription
        self.latitude = latitude
        self.longitude = longitude
        self.standardAvailability = standardAvailability
        self.currency = currency
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
