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
    let area: Area
    let cityType: CityType
    let city: String
    let addressType: AddressType
    let address, house, installPlace, locationNameDesc: String
    let workTime, timeLong, gpsX, gpsY: String
    let serviceTerminalCurrency: ServiceTerminalCurrency
    let infType: InfType
    let cashInExist, cashIn, typeCashIn, infPrinter: CashIn
    let regionPlatej, popolneniePlatej, infStatus: CashIn
    let coordinate: CLLocationCoordinate2D
    
    init(infoID: Int,
         area: Area,
         cityType: CityType,
         city: String,
         addressType: AddressType,
         address: String,
         house: String,
         installPlace: String,
         locationNameDesc: String,
         workTime: String,
         timeLong: String,
         gpsX: String,
         gpsY: String,
         serviceTerminalCurrency: ServiceTerminalCurrency,
         infType: InfType,
         cashInExist: CashIn,
         cashIn: CashIn,
         typeCashIn: CashIn,
         infPrinter: CashIn,
         regionPlatej: CashIn,
         popolneniePlatej: CashIn,
         infStatus: CashIn,
         coordinate: CLLocationCoordinate2D) {
        
        self.infoID = infoID
        self.area = area
        self.cityType = cityType
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
        self.serviceTerminalCurrency = serviceTerminalCurrency
        self.infType = infType
        self.cashInExist = cashInExist
        self.cashIn = cashIn
        self.typeCashIn = typeCashIn
        self.infPrinter = infPrinter
        self.regionPlatej = regionPlatej
        self.popolneniePlatej = popolneniePlatej
        self.infStatus = infStatus
        self.coordinate = coordinate
    }
}
