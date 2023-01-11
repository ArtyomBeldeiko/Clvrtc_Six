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
    let accountNumber: AccountNumber
    let equeue, wifi: Int
    let accessibilities: Accessibilities
    let branchBankAddress: BranchBankAddress
    let information: Information
    let services: BranchBankServices
    let coordinate: CLLocationCoordinate2D
    
    init(branchID: String,
         name: String,
         cbu: String,
         accountNumber: AccountNumber,
         equeue: Int,
         wifi: Int,
         accessibilities: Accessibilities,
         branchBankAddress: BranchBankAddress,
         information: Information,
         services: BranchBankServices,
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
}
