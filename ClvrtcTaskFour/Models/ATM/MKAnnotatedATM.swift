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
    let type: TypeEnum
    let baseCurrency: BaseCurrency
    let currency: Currency
    let cards: [Card]
    let currentStatus: CurrentStatus
    let address: Address
    let services: [Service]
    let availability: Availability
    let contactDetails: ContactDetails
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(address.geolocation.geographicCoordinates.latitude)!, longitude: Double(address.geolocation.geographicCoordinates.longitude)!)
    }
    
    init(atmID: String,
         type: TypeEnum,
         baseCurrency: BaseCurrency,
         currency: Currency,
         cards: [Card],
         currentStatus: CurrentStatus,
         address: Address,
         services: [Service],
         availability: Availability,
         contactDetails: ContactDetails,
         coordinate: CLLocationCoordinate2D) {
        
        self.atmID = atmID
        self.type = type
        self.baseCurrency = baseCurrency
        self.currency = currency
        self.cards = cards
        self.currentStatus = currentStatus
        self.address = address
        self.services = services
        self.availability = availability
        self.contactDetails = contactDetails
    }
}

