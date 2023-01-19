//
//  ATMData.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 30.12.22.
//

import Foundation

struct ATMData: Codable {
    let data: Data

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

struct Data: Codable {
    let atm: [ATM]

    enum CodingKeys: String, CodingKey {
        case atm = "ATM"
    }
}

struct ATM: Codable {
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

    enum CodingKeys: String, CodingKey {
        case atmID = "atmId"
        case type, baseCurrency, currency, cards, currentStatus
        case address = "Address"
        case services = "Services"
        case availability = "Availability"
        case contactDetails = "ContactDetails"
    }
}

struct Address: Codable {
    let streetName, buildingNumber, townName: String
    let countrySubDivision: CountrySubDivision
    let country: Country
    let addressLine: String
    let addressDescription: Description
    let geolocation: Geolocation

    enum CodingKeys: String, CodingKey {
        case streetName, buildingNumber, townName, countrySubDivision, country, addressLine
        case addressDescription = "description"
        case geolocation = "Geolocation"
    }
}

enum Description: String, Codable {
    case внешний = "Внешний"
    case внутренний = "Внутренний"
    case уличный = "Уличный"
}

enum Country: String, Codable {
    case by = "BY"
}

enum CountrySubDivision: String, Codable {
    case брестская = "Брестская"
    case витебская = "Витебская"
    case гомельская = "Гомельская"
    case гродненская = "Гродненская"
    case минск = "Минск"
    case минская = "Минская"
    case могилевская = "Могилевская"
}

struct Geolocation: Codable {
    let geographicCoordinates: GeographicCoordinates

    enum CodingKeys: String, CodingKey {
        case geographicCoordinates = "GeographicCoordinates"
    }
}

struct GeographicCoordinates: Codable {
    let latitude, longitude: String
}

struct Availability: Codable {
    let access24Hours, isRestricted, sameAsOrganization: Bool
    let standardAvailability: StandardAvailability

    enum CodingKeys: String, CodingKey {
        case access24Hours, isRestricted, sameAsOrganization
        case standardAvailability = "StandardAvailability"
    }
}

struct StandardAvailability: Codable {
    let day: [Day]

    enum CodingKeys: String, CodingKey {
        case day = "Day"
    }
}

struct Day: Codable {
    let dayCode: String
    let openingTime: OpeningTime
    let closingTime: ClosingTime
    let dayBreak: Break

    enum CodingKeys: String, CodingKey {
        case dayCode, openingTime, closingTime
        case dayBreak = "Break"
    }
}

enum ClosingTime: String, Codable {
    case the1300 = "13:00"
    case the1500 = "15:00"
    case the1545 = "15:45"
    case the1600 = "16:00"
    case the1615 = "16:15"
    case the1700 = "17:00"
    case the1730 = "17:30"
    case the1800 = "18:00"
    case the1900 = "19:00"
    case the2000 = "20:00"
    case the2100 = "21:00"
    case the2200 = "22:00"
    case the2300 = "23:00"
    case the2359 = "23:59"
    case the2400 = "24:00"
}

struct Break: Codable {
    let breakFromTime: BreakFromTime
    let breakToTime: BreakToTime
}

enum BreakFromTime: String, Codable {
    case the0000 = "00:00"
    case the0040 = "00:40"
    case the0100 = "01:00"
    case the0200 = "02:00"
    case the0400 = "04:00"
    case the1100 = "11:00"
    case the1230 = "12:30"
    case the1300 = "13:00"
    case the1400 = "14:00"
    case the1500 = "15:00"
}

enum BreakToTime: String, Codable {
    case the0000 = "00:00"
    case the0530 = "05:30"
    case the0700 = "07:00"
    case the0830 = "08:30"
    case the0900 = "09:00"
    case the1200 = "12:00"
    case the1315 = "13:15"
    case the1400 = "14:00"
    case the1415 = "14:15"
    case the1500 = "15:00"
    case the1700 = "17:00"
}

enum OpeningTime: String, Codable {
    case the0000 = "00:00"
    case the0430 = "04:30"
    case the0500 = "05:00"
    case the0600 = "06:00"
    case the0630 = "06:30"
    case the0700 = "07:00"
    case the0800 = "08:00"
    case the0830 = "08:30"
    case the0900 = "09:00"
    case the1000 = "10:00"
}

enum BaseCurrency: String, Codable {
    case byn = "BYN"
}

enum Card: String, Codable {
    case masterCard = "MasterCard"
    case upi = "UPI"
    case visa = "Visa"
    case белкарт = "БЕЛКАРТ"
    case мир = "МИР"
}

struct ContactDetails: Codable {
    let phoneNumber: String
}

enum Currency: String, Codable {
    case byn = "BYN "
    case bynUsd = "BYN USD "
    case usd = "USD "
    case empty = ""
}

enum CurrentStatus: String, Codable {
    case off = "Off"
    case on = "On"
}

struct Service: Codable {
    let serviceType: ServiceType
    let serviceDescription: String

    enum CodingKeys: String, CodingKey {
        case serviceType
        case serviceDescription = "description"
    }
}

enum ServiceType: String, Codable {
    case безналичныеПлатежи = "Безналичные платежи"
    case бесконтактноеCнятиеНаличных = "Бесконтактное cнятие наличных"
    case выдачаНаличных = "Выдача наличных"
    case изменениеPINКода = "Изменение PIN-кода"
    case обменВалюты = "Обмен валюты"
    case оплатаУслугМобильныхОператоров = "Оплата услуг мобильных операторов"
    case переводСКартыНаКарту = "Перевод с карты на карту"
    case платежиНаличными = "Платежи наличными"
    case получениеНаличныхПоКодуБезИспользованияКарты = "Получение наличных по коду без использования карты"
    case приемВыручки = "Прием выручки"
    case приемНаличных = "Прием наличных"
}

enum TypeEnum: String, Codable {
    case atm = "ATM"
}

