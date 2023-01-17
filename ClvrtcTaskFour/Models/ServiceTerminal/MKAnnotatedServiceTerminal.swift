//
//  MKAnnotatedServiceTerminal.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 12.01.23.
//

import Foundation
import MapKit

final class MKAnnotatedServiceTerminal: NSObject, MKAnnotation {
    let infoID: Int
    let city: String
    let addressType: String
    let address: String
    let house: String
    let installPlace: String
    let locationNameDesc: String
    let workTime: String
    let timeLong: String
    let gpsX: String
    let gpsY: String
    let currency: String
    let cashInExist: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(gpsX)!, longitude: Double(gpsY)!)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    init(infoID: Int,
         city: String,
         addressType: String,
         address: String,
         house: String,
         installPlace: String,
         locationNameDesc: String,
         workTime: String,
         timeLong: String,
         gpsX: String,
         gpsY: String,
         currency: String,
         cashInExist: String) {
        
        self.infoID = infoID
        self.city = city
        self.addressType = addressType
        self.address = address
        self.house = house
        self.installPlace = installPlace
        self.locationNameDesc = locationNameDesc
        self.workTime = workTime
        self.timeLong = timeLong
        self.gpsX = gpsX
        self.gpsY = gpsY
        self.currency = currency
        self.cashInExist = cashInExist
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
