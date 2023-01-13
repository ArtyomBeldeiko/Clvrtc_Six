//
//  ServiceTerminalData.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 10.01.23.
//

import Foundation

struct ServiceTerminal: Codable {
    let infoID: Int
    let area: Area
    let cityType: CityType
    let city: String
    let addressType: AddressType
    let address, house, installPlace, locationNameDesc: String
    let workTime, timeLong, gpsX, gpsY: String
    let currency: ServiceTerminalCurrency
    let infType: InfType
    let cashInExist, cashIn, typeCashIn, infPrinter: CashIn
    let regionPlatej, popolneniePlatej, infStatus: CashIn

    enum CodingKeys: String, CodingKey {
        case infoID = "info_id"
        case area
        case cityType = "city_type"
        case city
        case addressType = "address_type"
        case address, house
        case installPlace = "install_place"
        case locationNameDesc = "location_name_desc"
        case workTime = "work_time"
        case timeLong = "time_long"
        case gpsX = "gps_x"
        case gpsY = "gps_y"
        case currency
        case infType = "inf_type"
        case cashInExist = "cash_in_exist"
        case cashIn = "cash_in"
        case typeCashIn = "type_cash_in"
        case infPrinter = "inf_printer"
        case regionPlatej = "region_platej"
        case popolneniePlatej = "popolnenie_platej"
        case infStatus = "inf_status"
    }
}

enum AddressType: String, Codable {
    case addressType = "-"
    case empty = " "
    case бР = "б-р"
    case бул = "бул."
    case др = "др."
    case мкр = "мкр."
    case пер = "пер."
    case пл = "пл."
    case пос = "пос."
    case пр = "пр."
    case радОбщПользЯ = "РАД общ. польз-я"
    case ст = "ст."
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

enum CashIn: String, Codable {
    case да = "да"
    case нет = "нет"
}

enum CityType: String, Codable {
    case аг = "аг."
    case г = "г."
    case гП = "г.п."
    case гп = "гп"
    case д = "д."
    case кП = "к.п."
    case кп = "кп"
    case п = "п."
    case рН = "р-н"
    case рп = "рп"
    case сС = "с/с"
}

enum ServiceTerminalCurrency: String, Codable {
    case byn = "BYN,"
    case bynRub = "BYN,RUB,"
    case empty = ""
}

enum InfType: String, Codable {
    case внешний = "Внешний"
    case внутренний = "Внутренний"
}

typealias ServiceTerminalData = [ServiceTerminal]

