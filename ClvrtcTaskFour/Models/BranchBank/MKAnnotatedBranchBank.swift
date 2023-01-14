//
//  MKAnnotatedBranchBank.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 12.01.23.
//

import Foundation
import MapKit

final class MKAnnotatedBranchBank: NSObject, MKAnnotation {
    let branchID, name, cbu: String
    let accountNumber: String
    let equeue, wifi: Int
    let accessibilities: BankAccessibilities
    let branchBankAddress: BankAddress
    let information: BankInformation
    let services: BankServices
    let coordinate: CLLocationCoordinate2D
    
    var location: CLLocation {
        return CLLocation(latitude: Double(branchBankAddress.geoLocation.geographicCoordinates.latitude)!, longitude: Double(branchBankAddress.geoLocation.geographicCoordinates.latitude)!)
    }
    
    init(branchID: String,
         name: String,
         cbu: String,
         accountNumber: String,
         equeue: Int,
         wifi: Int,
         accessibilities: BankAccessibilities,
         branchBankAddress: BankAddress,
         information: BankInformation,
         services: BankServices,
         coordinate: CLLocationCoordinate2D) {
        
        self.branchID = branchID
        self.name = name
        self.cbu = cbu
        self.accountNumber = accountNumber
        self.equeue = equeue
        self.wifi = wifi
        self.accessibilities = accessibilities
        self.branchBankAddress = branchBankAddress
        self.information = information
        self.services = services
        self.coordinate = coordinate
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
