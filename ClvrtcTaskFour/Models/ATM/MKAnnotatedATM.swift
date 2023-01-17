//
//  MKAnnotatedATM.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 3.01.23.
//

import Foundation
import MapKit

final class MKAnnotatedATM: NSObject, MKAnnotation {
    let atmID: String
    let type: String
    let baseCurrency: String
    let currency: String
    let cards: String
    let currentStatus: String
    let streetName: String
    let townName: String
    let buildingNumber: String
    let addressLine: String
    let addressDiscription: String
    let latitude: String
    let longitude: String
    let serviceType: String
    let access24Hours: Bool
    let isRescticted: Bool
    let sameAsOrganization: Bool
    let standardAvailability: String
    let contactDetails: String
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    init(atmID: String,
         type: String,
         baseCurrency: String,
         currency: String,
         cards: String,
         currentStatus: String,
         streetName: String,
         townName: String,
         buildingNumber: String,
         addressLine: String,
         addressDiscription: String,
         latitude: String,
         longitude: String,
         serviceType: String,
         access24Hours: Bool,
         isRescticted: Bool,
         sameAsOrganization: Bool,
         standardAvailability: String,
         contactDetails: String) {
        
        self.atmID = atmID
        self.type = type
        self.baseCurrency = baseCurrency
        self.currency = currency
        self.cards = cards
        self.currentStatus = currentStatus
        self.streetName = streetName
        self.townName = townName
        self.buildingNumber = buildingNumber
        self.addressLine = addressLine
        self.addressDiscription = addressDiscription
        self.latitude = latitude
        self.longitude = longitude
        self.serviceType = serviceType
        self.access24Hours = access24Hours
        self.isRescticted = isRescticted
        self.sameAsOrganization = sameAsOrganization
        self.standardAvailability = standardAvailability
        self.contactDetails = contactDetails
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}

