//
//  BranchBankData.swift
//  ClvrtcTaskFour
//
//  Created by Artyom Beldeiko on 11.01.23.
//

import Foundation

struct BranchBankData: Codable {
    let branchBankData: BranchBankDataClass
    let links: Links
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case branchBankData = "Data"
        case links = "Links"
        case meta = "Meta"
    }
}

struct BranchBankDataClass: Codable {
    let branch: [Branch]

    enum CodingKeys: String, CodingKey {
        case branch = "Branch"
    }
}

struct Branch: Codable {
    let branchID, name, cbu: String
    let accountNumber: AccountNumber
    let equeue, wifi: Int
    let accessibilities: Accessibilities
    let branchBankAddress: BranchBankAddress
    let information: Information
    let services: BranchBankServices

    enum CodingKeys: String, CodingKey {
        case branchID = "branchId"
        case name
        case cbu = "CBU"
        case accountNumber, equeue, wifi
        case accessibilities = "Accessibilities"
        case branchBankAddress = "Address"
        case information = "Information"
        case services = "Services"
    }
}

struct Accessibilities: Codable {
    let accessibility: Accessibility

    enum CodingKeys: String, CodingKey {
        case accessibility = "Accessibility"
    }
}

struct Accessibility: Codable {
    let type: TypeUnion
    let description: String
}

enum TypeUnion: Codable {
    case enumeration(TypeType)
    case integer(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(TypeType.self) {
            self = .enumeration(x)
            return
        }
        throw DecodingError.typeMismatch(TypeUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TypeUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumeration(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        }
    }
}

enum TypeType: String, Codable {
    case wheelchairAccess = "WheelchairAccess"
}

enum AccountNumber: String, Codable {
    case by12Akbb38193821000310000000 = "BY12AKBB 3819 3821 0003 1000 0000"
    case by27Akbb38193821000300000000 = "BY27AKBB 3819 3821 0003 0000 0000"
    case by28Akbb38193821000170000000 = "BY28AKBB 3819 3821 0001 7000 0000"
    case by42Akbb38193821000290000000 = "BY42AKBB 3819 3821 0002 9000 0000"
    case by57Akbb38193821000280000000 = "BY57AKBB 3819 3821 0002 8000 0000"
    case by88Akbb38193821000130000000 = "BY88AKBB 3819 3821 0001 3000 0000"
    case by94Akbb38193821000320000000 = "BY94AKBB 3819 3821 0003 2000 0000"
}

struct BranchBankAddress: Codable {
    let streetName, buildingNumber, department, postCode: String
    let townName, countrySubDivision, country, addressLine: String
    let description: String
    let branchBankGeoLocation: BranchBankGeoLocation

    enum CodingKeys: String, CodingKey {
        case streetName, buildingNumber, department, postCode, townName, countrySubDivision, country, addressLine, description
        case branchBankGeoLocation = "GeoLocation"
    }
}

struct BranchBankGeoLocation: Codable {
    let geographicCoordinates: BranchBankGeographicCoordinates

    enum CodingKeys: String, CodingKey {
        case geographicCoordinates = "GeographicCoordinates"
    }
}

struct BranchBankGeographicCoordinates: Codable {
    let latitude, longitude: String
}

struct Information: Codable {
    let segment: Segment
    let branchBankAvailability: BranchBankAvailability
    let branchBankContactDetails: BranchBankContactDetails

    enum CodingKeys: String, CodingKey {
        case segment
        case branchBankAvailability = "Availability"
        case branchBankContactDetails = "ContactDetails"
    }
}

struct BranchBankAvailability: Codable {
    let access24Hours, isRestricted, sameAsOrganization: Int
    let description: String
    let branchBankStandardAvailability: BranchBankStandardAvailability
    let nonStandardAvailability: [NonStandardAvailability]

    enum CodingKeys: String, CodingKey {
        case access24Hours, isRestricted, sameAsOrganization, description
        case branchBankStandardAvailability = "StandardAvailability"
        case nonStandardAvailability = "NonStandardAvailability"
    }
}

struct NonStandardAvailability: Codable {
    let name, fromDate, toDate: String
    let description: NonStandardAvailabilityDescription
    let day: NonStandardAvailabilityDay

    enum CodingKeys: String, CodingKey {
        case name, fromDate, toDate, description
        case day = "Day"
    }
}

struct NonStandardAvailabilityDay: Codable {
    let dayCode, openingTime, closingTime: String
    let dayBreak: BranchBankBreak

    enum CodingKeys: String, CodingKey {
        case dayCode, openingTime, closingTime
        case dayBreak = "Break"
    }
}

struct BranchBankBreak: Codable {
    let breakFromTime, breakToTime: String
}

enum NonStandardAvailabilityDescription: String, Codable {
    case empty = ""
    case отделениеНеРаботает = "Отделение не работает"
}

struct BranchBankStandardAvailability: Codable {
    let day: [DayElement]

    enum CodingKeys: String, CodingKey {
        case day = "Day"
    }
}

struct DayElement: Codable {
    let dayCode: Int
    let openingTime, closingTime: String
    let dayBreak: Break

    enum CodingKeys: String, CodingKey {
        case dayCode, openingTime, closingTime
        case dayBreak = "Break"
    }
}

struct BranchBankContactDetails: Codable {
    let name, phoneNumber, mobileNumber, faxNumber: String
    let emailAddress, other: String
    let socialNetworks: [SocialNetwork]

    enum CodingKeys: String, CodingKey {
        case name, phoneNumber, mobileNumber, faxNumber, emailAddress, other
        case socialNetworks = "SocialNetworks"
    }
}

struct SocialNetwork: Codable {
    let networkName: NetworkName
    let url: String
    let description: SocialNetworkDescription
}

enum SocialNetworkDescription: String, Codable {
    case официальнаяСтраницаБеларусбанка = "Официальная страница Беларусбанка"
}

enum NetworkName: String, Codable {
    case facebook = "Facebook"
    case instagram = "Instagram"
    case ok = "OK"
    case telegram = "Telegram"
    case twitter = "Twitter"
    case viber = "Viber"
    case vk = "VK"
}

enum Segment: String, Codable {
    case business = "Business"
    case individual = "Individual"
}

struct BranchBankServices: Codable {
    let service: [BranchBankService]
    let currencyExchange: [BranchBankCurrencyExchange]

    enum CodingKeys: String, CodingKey {
        case service = "Service"
        case currencyExchange = "CurrencyExchange"
    }
}

struct BranchBankCurrencyExchange: Codable {
    let exchangeTypeStaticType: ExchangeTypeStaticType
    let sourceCurrency, targetCurrency: BranchBankCurrency
    let exchangeRate: String?
    let direction: Direction
    let scaleCurrency: String
    let dateTime: Date

    enum CodingKeys: String, CodingKey {
        case exchangeTypeStaticType = "ExchangeTypeStaticType"
        case sourceCurrency, targetCurrency, exchangeRate, direction, scaleCurrency, dateTime
    }
}

enum Direction: String, Codable {
    case buy = "buy"
    case sell = "sell"
}

enum ExchangeTypeStaticType: String, Codable {
    case cash = "Cash"
    case cashless = "Cashless"
}

enum BranchBankCurrency: String, Codable {
    case byn = "BYN"
    case cad = "CAD"
    case chf = "CHF"
    case cny = "CNY"
    case czk = "CZK"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case nok = "NOK"
    case pln = "PLN"
    case rub = "RUB"
    case sek = "SEK"
    case uah = "UAH"
    case usd = "USD"
}

struct BranchBankService: Codable {
    let serviceID: ServiceID
    let type: BranchBankServiceType?
    let name: String
    let segment: Segment
    let url: String
    let currentStatus: BranchBankCurrentStatus
    let dateTime: Date
    let description: String

    enum CodingKeys: String, CodingKey {
        case serviceID = "serviceId"
        case type, name, segment, url, currentStatus, dateTime, description
    }
}

enum BranchBankCurrentStatus: String, Codable {
    case active = "Active"
    case inactive = "Inactive"
}

enum ServiceID: String, Codable {
    case uslBroker = "usl_broker"
    case uslBuySlitki = "usl_buy_slitki"
    case uslCardInternet = "usl_card_internet"
    case uslCennieBumagi = "usl_cennie_bumagi"
    case uslCheckDoverVnebanka = "usl_check_dover_vnebanka"
    case uslChekiGilie = "usl_cheki_gilie"
    case uslChekiImuschestvo = "usl_cheki_imuschestvo"
    case uslClubBarhat = "usl_club_barhat"
    case uslClubKartblansh = "usl_club_kartblansh"
    case uslClubLedi = "usl_club_ledi"
    case uslClubNastart = "usl_club_nastart"
    case uslClubPersona = "usl_club_persona"
    case uslClubSchodry = "usl_club_schodry"
    case uslClubSvoi = "usl_club_svoi"
    case uslClubZclass = "usl_club_zclass"
    case uslCoinsExchange = "usl_coins_exchange"
    case uslDepDoverennosti = "usl_dep_doverennosti"
    case uslDepScheta = "usl_dep_scheta"
    case uslDepViplati = "usl_dep_viplati"
    case uslDepositariy = "usl_depositariy"
    case uslDocObligacBelarusbank = "usl_docObligac_belarusbank"
    case uslDoverUpr = "usl_dover_upr"
    case uslDoverUprGos = "usl_dover_upr_gos"
    case uslDragMetal = "usl_drag_metal"
    case uslIbank = "usl_ibank"
    case uslInkassoPriem = "usl_inkasso_priem"
    case uslInkassoPriemDenegBel = "usl_inkasso_priem_deneg_bel"
    case uslIntCards = "usl_int_cards"
    case uslIzbizSchetaOperacii = "usl_izbiz_scheta_operacii"
    case uslIzbizSchetaOtkr = "usl_izbiz_scheta_otkr"
    case uslKamniBrill = "usl_kamni_brill"
    case uslKonversiyaForeignVal = "usl_konversiya_foreign_val"
    case uslLoterei = "usl_loterei"
    case uslMoRb = "usl_mo_rb"
    case uslOperPoSchOtkrVRup = "usl_oper_po_sch_otkr_v_rup"
    case uslOperationsBezdokumentarObligacii = "usl_operations_bezdokumentar_obligacii"
    case uslOperationsSberSertif = "usl_operations_sber_sertif"
    case uslPerechisleniePoRekvizitamKartochki = "usl_perechislenie_po_rekvizitam_kartochki"
    case uslPerechislenieSoSchetaBezKart = "usl_perechislenie_so_scheta_bez_kart"
    case uslPlategi = "usl_plategi"
    case uslPlategiAll = "usl_plategi_all"
    case uslPlategiInForeignVal = "usl_plategi_in_foreign_val"
    case uslPlategiMinusInternet = "usl_plategi_minus_internet"
    case uslPlategiMinusMobi = "usl_plategi_minus_mobi"
    case uslPlategiMinusMobiInternetFull = "usl_plategi_minus_mobi_internet_full"
    case uslPlategiNalMinusKromeKredit = "usl_plategi_nal_minus_krome_kredit"
    case uslPlategiZaProezdVPolzuBanka = "usl_plategi_za_proezd_v_polzu_banka"
    case uslPodlinnostBanknot = "usl_podlinnost_banknot"
    case uslPogashenieDocumentarObligacii = "usl_pogashenie_documentar_obligacii"
    case uslPopolnenieSchetaBezKart = "usl_popolnenieSchetaBezKart"
    case uslPopolnenieSchetaBynISPKarts = "usl_popolnenieSchetaBynIspKarts"
    case uslPopolnenieSchetaUsdISPKarts = "usl_popolnenieSchetaUsdIspKarts"
    case uslPov = "usl_pov"
    case uslPriemCennosteiNaHranenie = "usl_priem_cennostei_na_hranenie"
    case uslPriemCennostejNaHranenie = "usl_priem_cennostej_na_hranenie"
    case uslPriemDocNaKreditsOverdrafts = "usl_priem_doc_na_kredits_overdrafts"
    case uslPriemDocNaLizing = "usl_priem_doc_na_lizing"
    case uslPriemDocPokupkaObl = "usl_priemDocPokupkaObl"
    case uslPriemDocsFLDepozitOperations = "usl_priem_docs_fl_depozit_operations"
    case uslPriemDocsVidachaSoprLgotIpotech = "usl_priem_docs_vidacha_sopr_lgot_ipotech"
    case uslPriemInkasso = "usl_priem_inkasso"
    case uslPriemOblMF = "usl_priem_obl_mf"
    case uslPriemPlatejeiBynIP = "usl_priem_platejei_byn_ip"
    case uslPriemPlatejeiEurIP = "usl_priem_platejei_eur_ip"
    case uslPriemVznosovInostrValOtStraxAgentov = "usl_priem_vznosov_inostr_val_ot_strax_agentov"
    case uslPriemZayvleniyObsluzhivanieDerzhatelej = "usl_priem_zayvleniy_obsluzhivanie_derzhatelej"
    case uslProdagaMonet = "usl_prodaga_monet"
    case uslRazmProdazhaDocumentarObligacii = "usl_razm_prodazha_documentar_obligacii"
    case uslRazmenForeignVal = "usl_razmen_foreign_val"
    case uslRbCard = "usl_rb_card"
    case uslRegistrationValDogovor = "usl_registration_val_dogovor"
    case uslReturnBynISPKarts = "usl_return_BynIspKarts"
    case uslReturnUsdISPKarts = "usl_return_UsdIspKarts"
    case uslRko = "usl_rko"
    case uslSeif = "usl_seif"
    case uslSoprovKreditVTomChisleMagnit = "usl_soprov_kredit_v_tom_chisle_magnit"
    case uslStrahovanieAvto = "usl_strahovanie_avto"
    case uslStrahovanieAvtoPogran = "usl_strahovanie_avto_pogran"
    case uslStrahovanieDetei = "usl_strahovanie_detei"
    case uslStrahovanieDohodPodZaschitoy = "usl_strahovanie_dohod_pod_zaschitoy"
    case uslStrahovanieExpress = "usl_strahovanie_express"
    case uslStrahovanieFinansPodZaschitoy = "usl_strahovanie_finans_pod_zaschitoy"
    case uslStrahovanieGreenKarta = "usl_strahovanie_green_karta"
    case uslStrahovanieHome = "usl_strahovanie_home"
    case uslStrahovanieKartochki = "usl_strahovanie_kartochki"
    case uslStrahovanieKasko = "usl_strahovanie_kasko"
    case uslStrahovanieKomplex = "usl_strahovanie_komplex"
    case uslStrahovanieMedicineNerezident = "usl_strahovanie_medicine_nerezident"
    case uslStrahovaniePerevozki = "usl_strahovanie_perevozki"
    case uslStrahovanieSZabotoiOBlizkih = "usl_strahovanie_s_zabotoi_o_blizkih"
    case uslStrahovanieTimeAbroad = "usl_strahovanie_timeAbroad"
    case uslStrahovanieZashhitaOtKleshha = "usl_strahovanie_zashhita_ot_kleshha"
    case uslStrahovkaSite = "usl_strahovka_site"
    case uslStroysber = "usl_stroysber"
    case uslStroysberNew = "usl_stroysber_new"
    case uslSubsidiyaScheta = "usl_subsidiya_scheta"
    case uslSwift = "usl_swift"
    case uslVidachSpravokPoKreditOverdr = "usl_vidach_spravok_po_kredit_overdr"
    case uslViplataVozmPoIncasso = "usl_viplata_vozm_po_incasso"
    case uslVklad = "usl_vklad"
    case uslVozvratNDS = "usl_vozvrat_nds"
    case uslVydachaNalVBanke = "usl_vydacha_nal_v_banke"
    case uslVydachaVypiski = "usl_vydacha_vypiski"
    case uslVypllataBelRub = "usl_vypllata_bel_rub"
    case uslVzk = "usl_vzk"
}

enum BranchBankServiceType: String, Codable {
    case card = "Card"
    case currencyExchange = "CurrencyExchange"
    case deposit = "Deposit"
    case jewel = "Jewel"
    case loan = "Loan"
    case other = "Other"
    case transfer = "Transfer"
}

struct Links: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "Self"
    }
}

struct Meta: Codable {
    let totalPages: String

    enum CodingKeys: String, CodingKey {
        case totalPages = "TotalPages"
    }
}

