//
//  ATM.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 30.12.22.
//

import Foundation

struct ATM: Codable {
    let id: String
    let area: Area
    let cityType: CityType
    let city: String
    let addressType: AddressType
    let address, house, installPlace, workTime: String
    let gpsX, gpsY, installPlaceFull, workTimeFull: String
    let atmType: ATMType
    let atmError: ATMError
    let currency: Currency
    let cashIn, atmPrinter: ATMError

    enum CodingKeys: String, CodingKey {
        case id, area
        case cityType = "city_type"
        case city
        case addressType = "address_type"
        case address, house
        case installPlace = "install_place"
        case workTime = "work_time"
        case gpsX = "gps_x"
        case gpsY = "gps_y"
        case installPlaceFull = "install_place_full"
        case workTimeFull = "work_time_full"
        case atmType = "ATM_type"
        case atmError = "ATM_error"
        case currency
        case cashIn = "cash_in"
        case atmPrinter = "ATM_printer"
    }
}

enum AddressType: String, Codable {
    case addressTypeУл = "ул. "
    case empty = ""
    case бул = "бул."
    case мкр = "мкр."
    case пер = "пер."
    case пл = "пл."
    case пос = "пос."
    case пр = "пр."
    case тракт = "тракт"
    case ул = "ул."
    case шоссе = "шоссе"
}

enum Area: String, Codable {
    case брестская = "Брестская"
    case витебская = "Витебская"
    case гомельская = "Гомельская"
    case гродненская = "Гродненская"
    case минск = "Минск"
    case минская = "Минская"
    case могилевская = "Могилевская"
}

enum ATMError: String, Codable {
    case да = "да"
    case нет = "нет"
}

enum ATMType: String, Codable {
    case внешний = "Внешний"
    case внутренний = "Внутренний"
    case уличный = "Уличный"
}

enum CityType: String, Codable {
    case empty = ""
    case аг = "аг."
    case г = "г."
    case гп = "гп"
    case д = "д."
    case кп = "кп"
    case п = "п."
    case рп = "рп"
}

enum Currency: String, Codable {
    case byn = "BYN   "
    case bynUsd = "BYN   USD   "
    case empty = ""
}

typealias ATMData = [ATM]



