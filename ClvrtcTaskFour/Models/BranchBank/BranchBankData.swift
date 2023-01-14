//
//  BranchBankData.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 11.01.23.
//

import Foundation

struct BankBranches: Codable {
    let data: BankData
    let links: BankLinks
    let meta: BankMeta

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case links = "Links"
        case meta = "Meta"
    }
}

struct BankData: Codable {
    let branch: [BankBranch]

    enum CodingKeys: String, CodingKey {
        case branch = "Branch"
    }
}

struct BankBranch: Codable {
    let branchId, name, cbu, accountNumber: String
    let equeue, wifi: Int
    let accessibilities: BankAccessibilities
    let address: BankAddress
    let information: BankInformation
    let services: BankServices

    enum CodingKeys: String, CodingKey {
        case branchId, name
        case cbu = "CBU"
        case accountNumber, equeue, wifi
        case accessibilities = "Accessibilities"
        case address = "Address"
        case information = "Information"
        case services = "Services"
    }
}

struct BankAccessibilities: Codable {
    let accessibility: BankAccessibility

    enum CodingKeys: String, CodingKey {
        case accessibility = "Accessibility"
    }
}

struct BankAccessibility: Codable {
    let type: BankType
    let description: String
}

enum BankType: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(BankType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for BankType"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

struct BankAddress: Codable {
    let streetName, buildingNumber, department, postCode: String
    let townName, countrySubDivision, country, addressLine: String
    let description: String
    let geoLocation: BankGeoLocation

    enum CodingKeys: String, CodingKey {
        case streetName, buildingNumber, department, postCode, townName, countrySubDivision, country, addressLine, description
        case geoLocation = "GeoLocation"
    }
}

struct BankGeoLocation: Codable {
    let geographicCoordinates: BankGeographicCoordinates

    enum CodingKeys: String, CodingKey {
        case geographicCoordinates = "GeographicCoordinates"
    }
}

struct BankGeographicCoordinates: Codable {
    let latitude, longitude: String
}

struct BankInformation: Codable {
    let segment: String
    let availability: BankAvailability
    let contactDetails: BankContactDetails

    enum CodingKeys: String, CodingKey {
        case segment
        case availability = "Availability"
        case contactDetails = "ContactDetails"
    }
}

struct BankAvailability: Codable {
    let access24Hours, isRestricted, sameAsOrganization: Int
    let description: String
    let standardAvailability: BankStandardAvailability
    let nonStandardAvailability: [BankNonStandardAvailability]

    enum CodingKeys: String, CodingKey {
        case access24Hours, isRestricted, sameAsOrganization, description
        case standardAvailability = "StandardAvailability"
        case nonStandardAvailability = "NonStandardAvailability"
    }
}

struct BankNonStandardAvailability: Codable {
    let name, fromDate, toDate, description: String
    let day: BankNonStandardAvailabilityDay

    enum CodingKeys: String, CodingKey {
        case name, fromDate, toDate, description
        case day = "Day"
    }
}

struct BankNonStandardAvailabilityDay: Codable {
    let dayCode, openingTime, closingTime: String
    let dayBreak: BankBreak

    enum CodingKeys: String, CodingKey {
        case dayCode, openingTime, closingTime
        case dayBreak = "Break"
    }
}

struct BankBreak: Codable {
    let breakFromTime, breakToTime: String
}

struct BankStandardAvailability: Codable {
    let day: [BankDayElement]

    enum CodingKeys: String, CodingKey {
        case day = "Day"
    }
}

struct BankDayElement: Codable {
    let dayCode: Int
    let openingTime, closingTime: String
    let dayBreak: BankBreak

    enum CodingKeys: String, CodingKey {
        case dayCode, openingTime, closingTime
        case dayBreak = "Break"
    }
}

struct BankContactDetails: Codable {
    let name, phoneNumber, mobileNumber, faxNumber: String
    let emailAddress, other: String
    let socialNetworks: [BankSocialNetwork]

    enum CodingKeys: String, CodingKey {
        case name, phoneNumber, mobileNumber, faxNumber, emailAddress, other
        case socialNetworks = "SocialNetworks"
    }
}

struct BankSocialNetwork: Codable {
    let networkName: String
    let url: String
    let description: String
}

struct BankServices: Codable {
    let service: [BankService]
    let currencyExchange: [BankCurrencyExchange]

    enum CodingKeys: String, CodingKey {
        case service = "Service"
        case currencyExchange = "CurrencyExchange"
    }
}

struct BankCurrencyExchange: Codable {
    let exchangeTypeStaticType, sourceCurrency, targetCurrency: String
    let exchangeRate: String?
    let direction, scaleCurrency, dateTime: String

    enum CodingKeys: String, CodingKey {
        case exchangeTypeStaticType = "ExchangeTypeStaticType"
        case sourceCurrency, targetCurrency, exchangeRate, direction, scaleCurrency, dateTime
    }
}

struct BankService: Codable {
    let serviceId: String
    let type: String?
    let name, segment: String
    let url: String
    let currentStatus, dateTime, description: String
}

struct BankLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "Self"
    }
}

struct BankMeta: Codable {
    let totalPages: String

    enum CodingKeys: String, CodingKey {
        case totalPages = "TotalPages"
    }
}

@propertyWrapper public struct NilOnFailBank<T: Codable>: Codable {
    
    public let wrappedValue: T?
    public init(from decoder: Decoder) throws {
        wrappedValue = try? T(from: decoder)
    }
    public init(_ wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}
